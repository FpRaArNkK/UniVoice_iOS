//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class AdmissionYearSelectionView: UIView {

    // MARK: Views
    let admissionSelctionLabel = UILabel()
    let admissionTextField = CustomTextfield()
    let admissionButton = UIButton()
    let menuTableView = UITableView()
    let departLabel = UILabel()
    let departTextField = CustomTextfield()
    let univLabel = UILabel()
    let univTextField = CustomTextfield()
    let nextButton = CustomButton(with: .inActive)
    
    private var isMenuOpen = true
    let menuItems = (28...34).reversed().map { "\($0)기" }
    
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
            admissionSelctionLabel,
            admissionTextField,
            admissionButton,
            departLabel,
            departTextField,
            univLabel,
            univTextField,
            menuTableView,
            nextButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        admissionSelctionLabel.do {
            $0.setText("학번을 선택해주세요", font: .T1SB, color: .B_01)
        }
        
        admissionTextField.do {
            $0.placeholder = "학번 선택하기"
            $0.isEnabled = false
        }
        
        menuTableView.do {
            $0.backgroundColor = .white
        }
        
        admissionButton.do {
            $0.setImage(.icnPolygonUp, for: .normal)
            $0.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        }
        
        departLabel.do {
            $0.setText("학과", font: .H6SB, color: .B_04)
        }
        
        departTextField.do {
            $0.isUserInteractionEnabled = false
        }
        
        univLabel.do {
            $0.setText("학교", font: .H6SB, color: .B_04)
        }
        
        univTextField.do {
            $0.isUserInteractionEnabled = false
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
        }
        
        menuTableView.do {
            $0.isHidden = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(CustomMenuTableViewCell.self, forCellReuseIdentifier: "CustomMenuTableViewCell")
            $0.layer.borderColor = UIColor(named: "Regular")?.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.rowHeight = 45
            $0.backgroundColor = .white
            $0.isScrollEnabled = false
            $0.separatorInset.left = 8
            $0.separatorInset.right = 8
            $0.backgroundColor = .white
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        admissionSelctionLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        admissionTextField.snp.makeConstraints {
            $0.top.equalTo(admissionSelctionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        admissionButton.snp.makeConstraints {
            $0.centerY.equalTo(admissionTextField)
            $0.trailing.equalTo(admissionTextField.snp.trailing)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(admissionTextField.snp.bottom)
            $0.trailing.equalTo(admissionTextField.snp.trailing)
            $0.width.equalTo(129)
            $0.height.equalTo(315)
        }
        
        departLabel.snp.makeConstraints {
            $0.top.equalTo(admissionTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        departTextField.snp.makeConstraints {
            $0.top.equalTo(departLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        univLabel.snp.makeConstraints {
            $0.top.equalTo(departTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        univTextField.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
        }
    }
    
    // MARK: Toggle Menu
    @objc private func toggleMenu() {
        isMenuOpen.toggle()
        menuTableView.isHidden = !isMenuOpen
        admissionButton.setImage(isMenuOpen ? .icnPolygonUp : .icnPolygonDown, for: .normal)
    }
}

extension AdmissionYearSelectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMenuTableViewCell", for: indexPath) as? CustomMenuTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        admissionTextField.text = selectedItem
        nextButton.bindData(buttonType: .just(.active))
        toggleMenu()
    }
}
