//
//  AdmissionYearSelectionVM.swift
//  UniVoice
//
//  Created by 이자민 on 7/18/24.
//

import RxSwift
import RxCocoa

final class AdmissionYearSelectionVM: ViewModelType {
    
    struct Input {
        let selectedAdmissionYear: Observable<String>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    private let selectedAdmissionYearRelay = BehaviorRelay<String?>(value: nil)
    
    func transform(input: Input) -> Output {
        input.selectedAdmissionYear
            .bind(to: selectedAdmissionYearRelay)
            .disposed(by: disposeBag)
        
        SignUpDataManager.shared.bindUniversityName(input.selectedAdmissionYear)
        
        return Output()
    }

}
