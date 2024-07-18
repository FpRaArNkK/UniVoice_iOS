//
//  SignUpDataManager.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import UIKit
import RxSwift

final class SignUpDataManager {
    static let shared = SignUpDataManager()
    
    private let disposeBag = DisposeBag()
    
    private let admissionNumberSubject = BehaviorSubject<String>(value: "")
    private let studentNameSubject = BehaviorSubject<String>(value: "")
    private let studentNumberSubject = BehaviorSubject<String>(value: "")
    private let emailSubject = BehaviorSubject<String>(value: "")
    private let passwordSubject = BehaviorSubject<String>(value: "")
    private let universityNameSubject = BehaviorSubject<String>(value: "")
    private let departmentNameSubject = BehaviorSubject<String>(value: "")
    private let studentCardImageSubject = BehaviorSubject<UIImage>(value: UIImage.emptyImage())
    
    private init() {}
    
    func bindAdmissionNumber(_ observable: Observable<String>) {
        observable.bind(to: admissionNumberSubject).disposed(by: disposeBag)
    }
    
    func bindStudentName(_ observable: Observable<String>) {
        observable.bind(to: studentNameSubject).disposed(by: disposeBag)
    }
    
    func bindStudentNumber(_ observable: Observable<String>) {
        observable.bind(to: studentNumberSubject).disposed(by: disposeBag)
    }
    
    func bindEmail(_ observable: Observable<String>) {
        observable.bind(to: emailSubject).disposed(by: disposeBag)
    }
    
    func bindPassword(_ observable: Observable<String>) {
        observable.bind(to: passwordSubject).disposed(by: disposeBag)
    }
    
    func bindUniversityName(_ observable: Observable<String>) {
        observable.bind(to: universityNameSubject).disposed(by: disposeBag)
    }
    
    func bindDepartmentName(_ observable: Observable<String>) {
        observable.bind(to: departmentNameSubject).disposed(by: disposeBag)
    }
    
    func bindStudentCardImage(_ observable: Observable<UIImage>) {
        observable.bind(to: studentCardImageSubject).disposed(by: disposeBag)
    }
    
    func getSignUpRequest() -> Observable<SignUpRequest> {
        return Observable.combineLatest(
            admissionNumberSubject,
            studentNameSubject,
            studentNumberSubject,
            emailSubject,
            passwordSubject,
            universityNameSubject,
            departmentNameSubject,
            studentCardImageSubject
        ) { (admissionNumber, name, studentNumber, email, password, universityName, departmentName, studentCardImage) in
            return SignUpRequest(
                admissionNumber: admissionNumber,
                name: name,
                studentNumber: studentNumber,
                email: email,
                password: password,
                universityName: universityName,
                departmentName: departmentName,
                studentCardImage: studentCardImage
            )
        }
    }
}
