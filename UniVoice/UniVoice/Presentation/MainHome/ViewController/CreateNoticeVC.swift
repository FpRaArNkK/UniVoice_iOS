//
//  CreateNoticeVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PhotosUI

final class CreateNoticeVC: UIViewController {
    
    // MARK: Properties
    private let rootView = CreateNoticeView()
    private let viewModel = CreateNoticeVM()
    private let disposeBag = DisposeBag()
    
    private let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "공지사항 작성"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        let customButton = rootView.createButton
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 47, height: 32))
        
        buttonContainer.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let rightButton = UIBarButtonItem(customView: buttonContainer)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let input = CreateNoticeVM.Input(
            titleText: rootView.titleTextField.rx.text.orEmpty.asObservable(),
            contentText: rootView.contentTextView.rx.text.orEmpty.asObservable(),
            selectedImages: selectedImagesRelay.asObservable(),
            targetContent: rootView.targetInputView.targetInputTextField.rx.text.orEmpty.asObservable(),
            startDate: rootView.dateInputView.startDatePicker.rx.date.map { $0 },
            finishDate: rootView.dateInputView.finishDatePicker.rx.date.map { $0 }
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonState
            .drive(onNext: { state in
                print(state)
                customButton.isUserInteractionEnabled = state.isEnabled
                customButton.configuration?.baseBackgroundColor = state.backgroundColor
            })
            .disposed(by: disposeBag)
        
        output.targetContent
            .drive(rootView.targetView.contentRelay)
            .disposed(by: disposeBag)
        
        output.startDate
            .map { $0?.toDateTimeString() ?? "" } // Convert Date to String
            .drive(rootView.dateView.startDateRelay)
            .disposed(by: disposeBag)
        
        output.finishDate
            .map { $0?.toDateString() ?? "" } // Convert Date to String
            .drive(rootView.dateView.finishDateRelay)
            .disposed(by: disposeBag)
        
        output.showImageCollection
            .drive(onNext: { [weak self] (show: Bool) in
                guard let self = self else { return }
                if show {
                    if !self.rootView.noticeStackView.arrangedSubviews.contains(self.rootView.imageCollectionView) {
                        self.rootView.noticeStackView.insertArrangedSubview(self.rootView.imageCollectionView, at: 0)
                    }
                } else {
                    self.rootView.imageCollectionView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        output.showTargetView
            .drive(onNext: { [weak self] (show: Bool) in
                guard let self = self else { return }
                if show {
                    if !self.rootView.noticeStackView.arrangedSubviews.contains(self.rootView.targetView) {
                        self.rootView.noticeStackView.addArrangedSubview(self.rootView.targetView)
                    }
                } else {
                    self.rootView.targetView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        output.showDateView
            .drive(onNext: { [weak self] (show: Bool) in
                guard let self = self else { return }
                if show {
                    if !self.rootView.noticeStackView.arrangedSubviews.contains(self.rootView.dateView) {
                        self.rootView.noticeStackView.addArrangedSubview(self.rootView.dateView)
                    }
                } else {
                    self.rootView.dateView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        rootView.imageButton.rx.tap
            .bind { [weak self] in
                self?.imageButtonTapped()
            }
            .disposed(by: disposeBag)
        
        rootView.targetButton.rx.tap
            .bind { [weak self] in
                self?.targetButtonTapped()
            }
            .disposed(by: disposeBag)
        
        let images: Observable<[UIImage]> = input.selectedImages.asObservable()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, UIImage>>(configureCell: { dataSource, collectionView, indexPath, image in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as? ImageCVC else {
                return UICollectionViewCell()
            }
            cell.imageView.image = image
            return cell
        })
        images
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.imageCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        rootView.imageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func imageButtonTapped() {
        let addImageAlert = UIAlertController(title: "사진 첨부하기", message: "왕서희야 여기 멘트 작성해놔라 ㅡㅡㅋ", preferredStyle: .actionSheet)
        
        let addImageAction = UIAlertAction(title: "이미지 첨부하기", style: .default) { [weak self] _ in
            self?.presentPHPicker()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        addImageAlert.addAction(addImageAction)
        addImageAlert.addAction(cancelAction)
        
        present(addImageAlert, animated: true)
        
    }
    
    private func targetButtonTapped() {
        if !self.rootView.subviews.contains(self.rootView.targetInputView) {
            self.rootView.addSubview(self.rootView.targetInputView)
            
            self.rootView.targetInputView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(195) // 원하는 높이로 설정
            }
        }
    }
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension CreateNoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 86, height: 86)
    }
}

extension CreateNoticeVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let imageProviders = results.map { $0.itemProvider }
        
        let dispatchGroup = DispatchGroup()
        var selectedImages = [UIImage]()
        
        for provider in imageProviders {
            dispatchGroup.enter()
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        selectedImages.append(image)
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.selectedImagesRelay.accept(selectedImages)
        }
    }
}
