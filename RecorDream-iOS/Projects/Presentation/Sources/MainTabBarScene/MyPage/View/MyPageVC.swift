//
//  MyPageVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/10/09.
//  Copyright © 2022 RecorDream. All rights reserved.
//

import UIKit

import RD_DSKit

import RxSwift
import SnapKit

public class MyPageVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    public var viewModel: MyPageViewModel!
  
    // MARK: - UI Components
    
    private let naviBar = RDNaviBar()
        .rightButtonImage(RDDSKitAsset.Images.icnBack.image)
        .title("마이페이지")
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = RDDSKitAsset.Images.icnMypage.image
        return iv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = RDDSKitFontFamily.Pretendard.semiBold.font(size: 16.adjusted)
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    private let editButton: UIButton = {
        let bt = UIButton()
        bt.setImage(RDDSKitAsset.Images.icnEdit.image, for: .normal)
        return bt
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "sample@naver.com"
        label.font = RDDSKitFontFamily.Pretendard.regular.font(size: 12.adjusted)
        label.textColor = .white.withAlphaComponent(0.5)
        label.sizeToFit()
        return label
    }()
    
    private let pushSettingView = MyPageInteractionView()
        .viewType(.pushOnOff)
    
    private let timeSettingView = MyPageInteractionView()
        .viewType(.timeSetting)
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "설정한 시간에 푸시알림을 통해 꿈을 바로 기록할 수 있어요!"
        label.font = RDDSKitFontFamily.Pretendard.regular.font(size: 12.adjustedH)
        label.textColor = .white.withAlphaComponent(0.4)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = RDDSKitAsset.Colors.purple.color
        bt.setTitle("로그아웃", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = RDDSKitFontFamily.Pretendard.semiBold.font(size: 16)
        bt.layer.cornerRadius = 15
        return bt
    }()
    
    private let withdrawlButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("탈퇴하기", for: .normal)
        bt.setUnderline()
        bt.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        bt.titleLabel?.font = RDDSKitFontFamily.Pretendard.regular.font(size: 14)
        return bt
    }()
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layouts

extension MyPageVC {
    private func setUI() {
        self.view.backgroundColor = RDDSKitAsset.Colors.dark.color
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, profileImageView, nickNameLabel,
                              editButton, emailLabel, pushSettingView,
                              timeSettingView, guideLabel, logoutButton,
                              withdrawlButton)
        
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(36.adjustedH)
            make.width.height.equalTo(90.adjusted)
            make.centerX.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8.adjustedH)
            make.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(3.adjusted)
            make.centerY.equalTo(nickNameLabel.snp.centerY)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5.adjustedH)
            make.centerX.equalToSuperview()
        }
        
        pushSettingView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(26.adjustedH)
            make.height.equalTo(64.adjustedH)
            make.leading.trailing.equalToSuperview().inset(16.adjusted)
        }
        
        timeSettingView.snp.makeConstraints { make in
            make.top.equalTo(pushSettingView.snp.bottom).offset(18.adjustedH)
            make.height.equalTo(64.adjustedH)
            make.leading.trailing.equalToSuperview().inset(16.adjusted)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25.adjusted)
            make.top.equalTo(timeSettingView.snp.bottom).offset(8.adjusted)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.adjusted)
            make.height.equalTo(50.adjustedH)
            make.bottom.equalTo(withdrawlButton.snp.top).offset(-12.adjusted)
        }
        
        withdrawlButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(safeAreaBottomInset() + 18)
        }
    }
}

// MARK: - Methods

extension MyPageVC {
    
}

// MARK: - Bind

extension MyPageVC {
  
    private func bindViewModels() {
        let input = MyPageViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }

}