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
    private let targetContentResultRelay = BehaviorRelay<String>(value: "")
    private let startDateRelay = BehaviorRelay<Date?>(value: nil)
    private let finishDateRelay = BehaviorRelay<Date?>(value: nil)
    private let isUsingTimeRelay = BehaviorRelay<Bool?>(value: nil)
    private var inputDates: (BehaviorRelay<Date>, BehaviorRelay<Date>)?
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
        setupKeyboardDismissalExceptComponent(exceptViews: [
            rootView.targetButton,
            rootView.imageButton,
            rootView.dateButton
        ])
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "공지사항 작성"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        targetContentResultRelay
            .bind(to: rootView.targetInputView.targetInputTextField.rx.text.orEmpty.asObserver())
            .disposed(by: disposeBag)
        
        let customButton = rootView.createButton
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 47, height: 32))
        
        buttonContainer.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let rightButton = UIBarButtonItem(customView: buttonContainer)
        self.navigationItem.rightBarButtonItem = rightButton
        
        inputDates = rootView.dateInputView.bindData(startDate: startDateRelay, endDate: finishDateRelay, isUsingTime: isUsingTimeRelay)
        
        let input = CreateNoticeVM.Input(
            titleText:
                rootView.titleTextField.rx.text.orEmpty.asObservable()
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            contentText:
                rootView.contentTextView.rx.text.orEmpty.asObservable(),
            isTextViewEmpty: rootView.isTextViewEmptyRelay.asObservable(),
            selectedImages: selectedImagesRelay.asObservable(),
            targetContenttext: rootView.targetInputView.targetInputTextField.rx.text.orEmpty.asObservable()
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            targetContentResult:
                targetContentResultRelay.asObservable(),
            startDate: startDateRelay.asObservable().compactMap { $0 },
            finishDate: finishDateRelay.asObservable().compactMap { $0 },
            isUsingTime: isUsingTimeRelay.asObservable().compactMap { $0 }, 
            postButtonDidTap: rootView.createButton.rx.tap.take(1)
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonState
            .drive(onNext: { state in
                customButton.isUserInteractionEnabled = state.isEnabled
                customButton.configuration?.baseBackgroundColor = state.backgroundColor
            })
            .disposed(by: disposeBag)
        
        output.targetContent
            .drive(rootView.targetView.contentRelay)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.startDate, output.isUsingTime)
            .map { date, includeTime in date!.toString(includeTime: includeTime) }
            .drive(rootView.dateView.startDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.finishDate, output.isUsingTime)
            .map { date, includeTime in date!.toString(includeTime: includeTime) }
            .drive(rootView.dateView.finishDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.showImageCollection
            .drive(onNext: { [weak self] show in
                self?.rootView.imageCollectionView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.showTargetView
            .drive(onNext: { [weak self] show in
                self?.rootView.targetView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.showDateView
            .drive(onNext: { [weak self] show in
                self?.rootView.dateView.isHidden = !show
            })
            .disposed(by: disposeBag)
        
        output.isTargetConfirmButtonEnabled
            .drive(rootView.targetInputView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.goNext.asObservable()
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let nextVC = UploadingNoticeVC(request: self.viewModel.getRequest())
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        let isTargetConfirmButtonEnabled = output.isTargetConfirmButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
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
        
        let targetViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(targetViewTapped))
        
        rootView.targetView.addGestureRecognizer(targetViewTapGesture)
        
        rootView.targetInputView.confirmButton.bindData(buttonType: isTargetConfirmButtonEnabled.asObservable())
        
        rootView.targetInputView.confirmButton.rx.tap
            .bind { [weak self] in
                self?.rootView.targetInputView.contentRelay.accept("")
                self?.targetConfirmButtonTapped()
            }
            .disposed(by: disposeBag)
        
        rootView.targetInputView.deleteButton.rx.tap
            .bind { [weak self] in
                self?.targetCancelButtonTapped()
            }
            .disposed(by: disposeBag)
        
        rootView.targetView.deleteButton.rx.tap
            .bind { [weak self] in
                self?.rootView.targetView.isHidden = true
                self?.targetContentResultRelay.accept("")
                
            }
            .disposed(by: disposeBag)
        
        rootView.dateView.deleteButton.rx.tap
            .bind { [weak self] in
                self?.rootView.dateView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        rootView.dateButton.rx.tap
            .bind { [weak self] in
                self?.dateButtonTapped()
            }
            .disposed(by: disposeBag)
        
        let dateViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        
        rootView.dateView.addGestureRecognizer(dateViewTapGesture)
        
        rootView.dateInputView.submitButton.rx.tap
            .bind { [weak self] in
                self?.rootView.dateView.isHidden = false
                self?.rootView.dateInputView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        rootView.dateInputView.dismissButton.rx.tap
            .bind { [weak self] in
                self?.rootView.dateInputView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        let images: Observable<[UIImage]> = input.selectedImages.asObservable()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, UIImage>>(configureCell: { dataSource, collectionView, indexPath, image in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as? ImageCVC else {
                return UICollectionViewCell()
            }
            cell.imageView.image = image
            cell.deleteButton.rx.tap
                .bind { [weak self] in
                    self?.deleteImage(at: indexPath)
                }
                .disposed(by: cell.disposeBag)
            return cell
        })
        images
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.imageCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        rootView.imageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        selectedImagesRelay
            .map { $0.count < 5 }
            .bind(to: rootView.imageButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
    }
    
    private func imageButtonTapped() {
        let addImageAlert = UIAlertController(title: "사진 첨부하기", message: "공지사항에 들어 갈 사진을 선택해주세요 (최대 5장)", preferredStyle: .actionSheet)
        
        let addImageAction = UIAlertAction(title: "이미지 첨부하기", style: .default) { [weak self] _ in
            self?.presentPHPicker()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        addImageAlert.addAction(addImageAction)
        addImageAlert.addAction(cancelAction)
        
        if !selectedImagesRelay.value.isEmpty {
            let selectedImagesAlert = UIAlertController(title: "현재 선택된 이미지", message: nil, preferredStyle: .alert)
            
            for image in selectedImagesRelay.value {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
                selectedImagesAlert.view.addSubview(imageView)
            }
            
            selectedImagesAlert.addAction(UIAlertAction(title: "확인", style: .default))
        }
        
        present(addImageAlert, animated: true)
    }
    
    private func targetButtonTapped() {
        self.rootView.targetInputView.isHidden = false
        self.rootView.targetInputView.targetInputTextField.becomeFirstResponder()
    }
    
    @objc private func targetViewTapped() {
        self.rootView.targetInputView.isHidden = false
    }
    
    private func targetCancelButtonTapped() {
        if targetContentResultRelay.value.isEmpty {
            self.targetContentResultRelay.accept("")
        } else {
            if let targetText = self.rootView.targetView.contentLabel.text {
                self.targetContentResultRelay.accept(targetText)
            }
        }
        self.rootView.targetInputView.isHidden = true
    }
    
    private func targetConfirmButtonTapped() {
        if let targetText = self.rootView.targetInputView.targetInputTextField.text {
            self.targetContentResultRelay.accept(targetText)
        }
        self.rootView.targetInputView.isHidden = true
    }
    
    private func dateButtonTapped() {
        self.rootView.dateInputView.isHidden = false
        view.endEditing(true)
    }
    
    @objc private func dateViewTapped() {
        self.rootView.dateInputView.isHidden = false
        if let startDate = startDateRelay.value,
           let endDate = finishDateRelay.value {
            inputDates?.0.accept(startDate)
            inputDates?.1.accept(endDate)
        }
    }

    private func deleteImage(at indexPath: IndexPath) {
        var images = selectedImagesRelay.value
        print(indexPath.row)
        images.remove(at: indexPath.row)
        selectedImagesRelay.accept(images)
    }
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5 - selectedImagesRelay.value.count
        
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
        var selectedImages = selectedImagesRelay.value
        
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
