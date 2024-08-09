//
//  LoginViewModel.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import RxSwift
import RxCocoa

enum LoginButtonState {
    case idIsEditingWithoutPW
    case pwIsEditingWithoutID
    case bothIsFilled
    case none
}

final class LoginVM: ViewModelType {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
        let loginButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let loginButtonIsEnabled: Driver<Bool>
        let loginButtonState: Driver<LoginButtonState>
        let loginState: Driver<Bool>
    }
    
    private let idTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    private let pwTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let loginButtonIsEnabled = Observable
            .combineLatest(
                input.idText,
                input.pwText,
                idTextFieldCompletedRelay,
                pwTextFieldCompletedRelay
            )
            .map { id, pw, idCompleted, pwCompleted in
                if idCompleted {
                    return !pw.isEmpty
                } else if pwCompleted {
                    return !id.isEmpty
                } else {
                    return !id.isEmpty || !pw.isEmpty
                }
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let loginButtonState = input.loginButtonDidTap
            .withLatestFrom(Observable.combineLatest(input.idText, input.pwText))
            .map { [weak self] id, pw in
                if !id.isEmpty && pw.isEmpty {
                    self?.idTextFieldCompletedRelay.accept(true)
                    return LoginButtonState.idIsEditingWithoutPW
                } else if id.isEmpty && !pw.isEmpty {
                    self?.pwTextFieldCompletedRelay.accept(true)
                    return LoginButtonState.pwIsEditingWithoutID
                } else if !id.isEmpty && !pw.isEmpty {
                    return LoginButtonState.bothIsFilled
                } else {
                    return LoginButtonState.none
                }
            }
            .asDriver(onErrorJustReturn: LoginButtonState.none)
        
        let credentials = Observable
                   .combineLatest(input.idText, input.pwText)
        
        let loginState = loginButtonState
            .asObservable()
            .filter { $0 == .bothIsFilled }
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
