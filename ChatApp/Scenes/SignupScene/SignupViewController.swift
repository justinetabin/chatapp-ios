//
//  SignupViewController.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/7/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: BaseViewController<SignupViewModel> {
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "username"
        view.borderStyle = .roundedRect
        view.autocapitalizationType = .none
        return view
    }()
    
    var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "password"
        view.isSecureTextEntry = true
        view.borderStyle = .roundedRect
        view.autocapitalizationType = .none
        return view
    }()
    
    var signupButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Signup", for: .normal)
        return view
    }()
    
    var loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Login", for: .normal)
        return view
    }()
    
    var notifView: HamburgerNotifView = {
        let view = HamburgerNotifView()
        return view
    }()
    
    fileprivate func setupSubviews() {
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.loginButton)
        self.containerView.addSubview(self.usernameTextField)
        self.containerView.addSubview(self.passwordTextField)
        self.containerView.addSubview(self.signupButton)
        
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }
        
        self.usernameTextField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(20)
        }
        
        self.signupButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottomMargin).inset(20)
        }
        
        self.notifView.attachIn(view: self.view)
    }
    
    fileprivate func bindViews() {
        
        // signup button tapped
        self.signupButton.rx.tap
            .bind(to: self.viewModel.input.didTapSignup)
            .disposed(by: self.disposeBag)
        
        // login button tapped
        self.loginButton.rx.tap
            .bind(to: self.viewModel.input.didTapLogin)
            .disposed(by: self.disposeBag)
        
        // username textfield changed
        self.usernameTextField.rx.text.map { $0 ?? "" }
            .bind(to: self.viewModel.input.usernameEditingChanged)
            .disposed(by: self.disposeBag)
        
        // password textfield changed
        self.passwordTextField.rx.text.map { $0 ?? "" }
            .bind(to: self.viewModel.input.passwordEditingChanged)
            .disposed(by: self.disposeBag)
        
        // show login scene
        self.viewModel.output.showLoginScene.bind { [unowned self] (_) in
            let vc = self.factory.makeLoginScene()
            self.navigationController?.setViewControllers([vc], animated: true)
        }.disposed(by: self.disposeBag)
        
        // show chat scene
        self.viewModel.output.showChatScene.bind { [unowned self] (_) in
            let vc = self.factory.makeChatScene()
            self.navigationController?.setViewControllers([vc], animated: true)
        }.disposed(by: self.disposeBag)
        
        // show error
        self.viewModel.output.showError
            .bind { [weak self] (text) in
                self?.notifView.show(text: text, hidesAfter: 2)
            }.disposed(by: self.disposeBag)
        
        self.viewModel.output.signupEnabled
            .bind(to: self.signupButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.bindViews()
    }
}
