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

final class StudentIDPhotoInputVC: UIViewController {
    
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
        
        output.nextButtonIsHidden
            .drive { [weak self] isHidden in
                self?.rootView.nextButton.isHidden = isHidden
            }
            .disposed(by: viewModel.disposeBag)
        
        output.image
            .drive { [weak self] image in
                self?.rootView.studentIDPhotoimgaeView.image = image
                self?.rootView.studentIDPhotoimgaeView.layer.borderWidth = 0
                self?.rootView.putPhotoLabel.isHidden = true
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
    
    // MARK: - Image Select(PHPicker)
    @objc
    private func imageViewDidTap() {
        if rootView.studentIDPhotoimgaeView.image == nil {
            rootView.studentIDPhotoimgaeView.layer.borderWidth = 1
        }
        
        let addImageAlert = UIAlertController(title: "사진 첨부하기",
                                              message: "먼저 실물 학생증이나 모바일 학생증을 카메라로 촬영해주세요",
                                              preferredStyle: .actionSheet)
        
        let addImageAction = UIAlertAction(title: "이미지 첨부하기", style: .default) { [weak self] _ in
            self?.checkPhotoLibraryPermission(completion: { [weak self] isAccessible in
                isAccessible ? self?.presentPHPicker() : self?.showAccessDeniedAlert()
            })
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { [weak self] _ in
            self?.rootView.studentIDPhotoimgaeView.layer.borderWidth = 0
        }
        addImageAlert.addAction(addImageAction)
        addImageAlert.addAction(cancelAction)
        
        present(addImageAlert, animated: true)
    }
    
    // TODO : escaping 클로저 RxSwift로 리팩토링
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        // 사진 접근 권한 상태
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            // 초기 진입시 접근 권한 설정 안 돼 있음므로 접근 권한 요청
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { statusForRequest in
                DispatchQueue.main.async {
                    completion(statusForRequest == .authorized || statusForRequest == .limited)
                }
            }
        default:
            completion(false)
        }
    }
    
    // 사진 선택을 위한 PHPicker 호출
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
        
        // 설정으로 화면 전환을 위한 Action
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

// MARK: - PHPickerViewControllerDelegate
extension StudentIDPhotoInputVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        // provider(item 즉 image)가 UIImage로 Load 가능한지 판별 후 이미지 처리
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                self?.selectedImageSubject.onNext(image)
            }
        }
    }
}
