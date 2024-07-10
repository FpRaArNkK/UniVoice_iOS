//
//  StudentIDPhotoInputVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class StudentIDPhotoInputVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = StudentIDPhotoInputView()
    private let viewModel = StudentIDPhotoInputVM()
    private let selectedImageSubject = PublishSubject<UIImage>()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindUI()
        setUpFoundation()
    }
    
    // MARK: - setUpBindUI
    private func setUpBindUI() {
        let input = StudentIDPhotoInputVM.Input(imageSelected: selectedImageSubject)
        
        let output = viewModel.transform(input: input)
        
        let nextButtonState = output.nextButtonState
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: nextButtonState.asObservable())
        
        output.image
            .drive { [weak self] image in
                self?.rootView.studentIDPhotoimgaeView.image = image
                self?.rootView.studentIDPhotoimgaeView.layer.borderWidth = 0
            }
            .disposed(by: viewModel.disposeBag)
        
        rootView.nextButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let photoImageRelay = self?.viewModel.photoImageRelay else { return }
                
                let viewModel = StudentInfoInputVM(photoImageRelay: photoImageRelay)
                let viewController = StudentInfoInputVC(viewModel: viewModel)
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    // MARK: - setUpFoundation
    private func setUpFoundation() {
        self.title = "학생증 인증"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        rootView.studentIDPhotoimgaeView.addGestureRecognizer(tapGesture)
        rootView.studentIDPhotoimgaeView.isUserInteractionEnabled = true
    }
    
    @objc
    private func imageViewDidTap() {
        rootView.studentIDPhotoimgaeView.image = .imageInputSelected
        
        let addImageAlert = UIAlertController(title: "사진 첨부하기",
                                              message: "먼저 실물 학생증이나 모바일 학생증을 카메라로 촬영해주세요",
                                              preferredStyle: .actionSheet)
        
        let addImageAction = UIAlertAction(title: "이미지 첨부하기", style: .default) { [weak self] _ in
            self?.checkPhotoLibraryPermission(completion: { [weak self] granted in
                granted ? self?.presentPHPicker() : self?.showAccessDeniedAlert()
            })
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { [weak self] _ in
            self?.rootView.studentIDPhotoimgaeView.image = .imageInputUnselected
        }
        addImageAlert.addAction(addImageAction)
        addImageAlert.addAction(cancelAction)
        
        present(addImageAlert, animated: true)
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { statusForRequest in
                completion(statusForRequest == .authorized || statusForRequest == .limited)
            }
        default:
            completion(false)
        }
    }
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showAccessDeniedAlert() {
        let alert = UIAlertController(title: "사진 접근 권한 필요",
                                      message: "학생증 인증을 위해 사진 접근 권한이 필요합니다. 설정에서 권한을 허용해 주세요.",
                                      preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension StudentIDPhotoInputVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                self?.selectedImageSubject.onNext(image)
            }
        }
    }
}
