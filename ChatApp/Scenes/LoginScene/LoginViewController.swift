//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: BaseViewController<LoginViewModel> {
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "username"
        view.borderStyle = .roundedRect
        return view
    }()
    
    var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "password"
        view.isSecureTextEntry = true
        view.borderStyle = .roundedRect
        return view
    }()
    
    var loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Login", for: .normal)
        return view
    }()
    
    var signupButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Signup", for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.signupButton)
        self.containerView.addSubview(self.usernameTextField)
        self.containerView.addSubview(self.passwordTextField)
        self.containerView.addSubview(self.loginButton)
        
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
        
        self.loginButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
        }
        
        self.signupButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
    }
}
