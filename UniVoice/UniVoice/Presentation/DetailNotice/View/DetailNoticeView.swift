//
//  DetailNoticeView.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit

final class DetailNoticeView: UIView {

    // MARK: Views
    
    let mainTitleLabel = UILabel()
    
    let divider = UIView()
    
    let mainInfoStackView = UIStackView() // subInfo + (Image)
    
    let basicInfoStackView = UIView() //대상 + 일시
    
    let targetLabel = UILabel()
    
    let dateLabel = UILabel()
        
    let imageStackView = UIStackView() //0장, 1장, 2장 이상
    
    let noticeImageCollectionView = UICollectionView() //이거 없을 수도 있음!!!!!!!!!!!!!
    
    let segmentControlView = UIView() //사진 하나면 이거 없음
        
    let explanationLabel= UILabel()
    
    let subInfoStackView = UIStackView() //업로드일시, 조회수
    
    let uploadDateLabel() = UILabel()
    
    let viewLabel = UILabel()
    
    let buttonStackView = UIStackView()
    
    let likedButton = UIButton()
    
    let savedButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
    }
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            mainTitleLabel,
            divider,
            mainInfoStackView,
            explanationLabel,
            subInfoStackView,
            buttonStackView
        ].forEach { self.addSubview($0) }
        
        [
            basicInfoStackView,
            imageStackView
        ].forEach { mainInfoStackView.addSubview($0) }
        
        [
            targetLabel,
            dateLabel
        ].forEach { basicInfoStackView.addSubview($0) }
        
        [
            noticeImageCollectionView,
            segmentControlView
        ].forEach { imageStackView.addSubview($0) }
        
        [
            uploadDateLabel,
            viewLabel
        ].forEach { subInfoStackView.addSubview($0) }
        
        [
            likedButton,
            savedButton
        ].forEach { buttonStackView.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        mainTitleLabel.do {
            $0.setText("컴퓨터공학과 간식행사 안내",
                       font: .H5SB, ///수정 필요
                       color: .black)
        }
        divider.do {
            $0.backgroundColor = .regular
        }
        explanationLabel.do {
            $0.setText("시험기간 공부하시느라 힘드시죠??\noo학생회에서 간식꾸러미를 준비했습니다!\n가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야", font: .B1R, color: .black)
        }
        uploadDateLabel.do {
            $0.setText("지금", font: .B4R, color: .b03)
        }
        viewLabel.do {
            $0.setText("조회수 33", font: .B4R, color: .b03)
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {

    }
}
