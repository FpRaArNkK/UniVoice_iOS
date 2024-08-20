//
//  LoginViewModel.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import RxSwift
import RxCocoa

/// 로그인 버튼이 표시되는 상태입니다.
enum LoginButtonState {
    /// ID 입력 중, PW 미입력 상태
    case idIsEditingWithoutPW
    /// PW 입력 중, ID 미입력 상태
    case pwIsEditingWithoutID
    /// ID와 PW 모두 입력된 상태
    case bothIsFilled
    /// 아무 것도 입력되지 않은 상태
    case none
}

final class LoginVM: ViewModelType {
    
    struct Input {
        /// ID 텍스트 필드의 입력 값
        let idText: Observable<String>
        /// PW 텍스트 필드의 입력 값
        let pwText: Observable<String>
        /// 로그인 버튼 탭 이벤트
        let loginButtonDidTap: Observable<Void>
    }
    
    struct Output {
        /// 로그인 버튼 상태
        let loginButtonState: Driver<LoginButtonState>
        /// 로그인 성공 여부
        let loginState: Driver<Bool>
    }
    
    /// ID 텍스트 필드 완료 상태를 관리하는 Relay
    private let idTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    /// PW 텍스트 필드 완료 상태를 관리하는 Relay
    private let pwTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // ID와 PW의 유효성 검사
        let credentials = Observable.combineLatest(input.idText, input.pwText)
        
        // 로그인 버튼 상태 및 활성화 여부를 결정하는 로직
        let loginButtonState = credentials
            .map { id, pw -> LoginButtonState in
                if !id.isEmpty && pw.isEmpty {
                    return .idIsEditingWithoutPW
                } else if id.isEmpty && !pw.isEmpty {
                    return .pwIsEditingWithoutID
                } else if !id.isEmpty && !pw.isEmpty {
                    return .bothIsFilled
                } else {
                    return .none
                }
            }
            .asDriver(onErrorJustReturn: .none)
        
        // 로그인 상태를 결정하는 로직
        let loginState = input.loginButtonDidTap
            .withLatestFrom(loginButtonState)
            .filter { $0 == .bothIsFilled }
            .withLatestFrom(credentials)
            .flatMapLatest { [weak self] id, pw in
                self?.login(id: id, password: pw) ?? .just(false)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            loginButtonState: loginButtonState,
            loginState: loginState
        )
    }
}

// MARK: API Logic
extension LoginVM {
    private func login(id: String, password: String) -> Observable<Bool> {
        return Service.shared.login(request: .init(email: id, password: password))
            .asObservable()
            .map { response in
                return response.status == 200
            }
            .catchAndReturn(false)
    }
}
