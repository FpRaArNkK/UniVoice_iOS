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
        /// 로그인 버튼 활성화 여부
        let loginButtonIsEnabled: Driver<Bool>
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
        // 로그인 버튼 활성화 여부를 계산
        let loginButtonIsEnabled = Observable
            .combineLatest(
                input.idText,
                input.pwText,
                idTextFieldCompletedRelay,
                pwTextFieldCompletedRelay
            )
            .map { id, pw, idCompleted, pwCompleted in
                if idCompleted {
                    return !pw.isEmpty // pw가 작성되었는지
                } else if pwCompleted {
                    return !id.isEmpty // id가 작성되었는지
                } else {
                    return !id.isEmpty || !pw.isEmpty // 둘 중 하나라도 작성되었는지
                }
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        // 로그인 버튼 상태를 결정
        let loginButtonState = input.loginButtonDidTap
            .withLatestFrom(Observable.combineLatest(input.idText, input.pwText))
            .map { [weak self] id, pw in
                if !id.isEmpty && pw.isEmpty { // id 작성, pw 미작성
                    self?.idTextFieldCompletedRelay.accept(true)
                    return LoginButtonState.idIsEditingWithoutPW
                } else if id.isEmpty && !pw.isEmpty { // id 미작성, pw 작성
                    self?.pwTextFieldCompletedRelay.accept(true)
                    return LoginButtonState.pwIsEditingWithoutID
                } else if !id.isEmpty && !pw.isEmpty { // 모두 작성
                    return LoginButtonState.bothIsFilled
                } else { // 모두 미작성
                    return LoginButtonState.none
                }
            }
            .asDriver(onErrorJustReturn: LoginButtonState.none)
        
        // ID와 PW 입력 값 합성
        let credentials = Observable
            .combineLatest(input.idText, input.pwText)
        
        // 로그인 상태를 결정하는 로직
        let loginState = loginButtonState
            .asObservable()
            .filter { $0 == .bothIsFilled } // 모두 작성되었을 때만
            .withLatestFrom(credentials)
            .flatMapLatest { [weak self] id, pw in
                self?.login(id: id, password: pw) ?? .just(false) // 로그인 로직 호출
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            loginButtonIsEnabled: loginButtonIsEnabled,
            loginButtonState: loginButtonState,
            loginState: loginState)
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
