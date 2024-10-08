//
//  TOSCheckVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

// 체크박스의 상태를 나타내는 enum
enum CheckBoxState {
    case checked
    case unchecked
}

final class TOSCheckVM: ViewModelType {
    
    struct Input {
        let overallAgreeCheckBoxDidTap: Observable<Void>
        let serviceTermsCheckBoxDidTap: Observable<Void>
        let personalInfoTOSCheckBoxDidTap: Observable<Void>
    }
    
    struct Output {
        let overallAgreeCheckBoxState: Driver<CheckBoxState>
        let serviceTermsCheckBoxState: Driver<CheckBoxState>
        let personalInfoTOSCheckBoxState: Driver<CheckBoxState>
        let completeButtonState: Driver<Bool>
    }
    
    // 각 체크박스의 상태를 관리하는 Relay
    private var overallAgreeCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    private var serviceTermsCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    private var personalInfoTOSCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.overallAgreeCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.overallAgreeCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind { newState in
                self.overallAgreeCheckBoxRelay.accept(newState)
                self.serviceTermsCheckBoxRelay.accept(newState)
                self.personalInfoTOSCheckBoxRelay.accept(newState)
            }
            .disposed(by: disposeBag)
        
        input.serviceTermsCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.serviceTermsCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind(onNext: { [weak self] newState in
                self?.serviceTermsCheckBoxRelay.accept(newState)
                self?.updateOverallAgreeCheckBox()
            })
            .disposed(by: disposeBag)
        
        input.personalInfoTOSCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.personalInfoTOSCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind(onNext: { [weak self] newState in
                self?.personalInfoTOSCheckBoxRelay.accept(newState)
                self?.updateOverallAgreeCheckBox()
            })
            .disposed(by: disposeBag)
        
        let completeButtonState = overallAgreeCheckBoxRelay
            .map { currentState in
                return currentState == .checked ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            overallAgreeCheckBoxState: overallAgreeCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            serviceTermsCheckBoxState: serviceTermsCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            personalInfoTOSCheckBoxState: personalInfoTOSCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            completeButtonState: completeButtonState
        )
    }
    
    // 전체 동의 체크박스의 상태를 개별 체크박스의 상태에 따라 업데이트
    private func updateOverallAgreeCheckBox() {
        let serviceTermsCheckBoxState = serviceTermsCheckBoxRelay.value == .checked
        let personalInfoTOSCheckeBoxState = personalInfoTOSCheckBoxRelay.value == .checked
        let newState: CheckBoxState = (serviceTermsCheckBoxState && personalInfoTOSCheckeBoxState) ? .checked : .unchecked
        overallAgreeCheckBoxRelay.accept(newState)
    }
}

// swiftlint: disable line_length
// swiftlint: disable non_optional_string_data_conversion
// URLSession을 활용하여 multipart/form 네트워크 통신
extension TOSCheckVM {
    private func createMultipartFormDataBody(with parameters: [String: String], boundary: String, image: UIImage, imageName: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        let imageData = image.compressed(to: 1.0)!
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"studentCardImage\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func requestSignUp(signUpRequest: SignUpRequest) -> Observable<Bool> {
            return Observable.create { observer in
                let url = URL(string: "\(Config.baseURL)/auth/signup")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = UUID().uuidString
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let parameters: [String: String] = [
                    "admissionNumber": signUpRequest.admissionNumber,
                    "name": signUpRequest.name,
                    "studentNumber": signUpRequest.studentNumber,
                    "email": signUpRequest.email,
                    "password": signUpRequest.password,
                    "universityName": signUpRequest.universityName,
                    "departmentName": signUpRequest.departmentName
                ]
                
                let body = self.createMultipartFormDataBody(with: parameters, boundary: boundary, image: signUpRequest.studentCardImage, imageName: "student_card.jpg")
                request.httpBody = body
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                        observer.onError(error)
                        return
                    }
                    
                    if (200...299).contains(httpResponse.statusCode) {
                        observer.onNext(true)
                        observer.onCompleted()
                    } else {
                        let error = NSError(domain: "Server error", code: httpResponse.statusCode, userInfo: nil)
                        observer.onError(error)
                    }
                }
                
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            }
        }
}
// swiftlint: enable line_length
// swiftlint: enable non_optional_string_data_conversion
