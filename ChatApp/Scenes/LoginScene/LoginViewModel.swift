//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    init(factory: WorkerFactory) {
        super.init()
        let worker = factory.makeCachedUsersWorker()
        
        self.input.viewWillAppear
            .bind { [weak self] (_) in
                worker.getLoggedInUser { (user) in
                    if user != nil {
                        self?.output.showChatScene.accept(())
                    }
                }
            }.disposed(by: self.disposeBag)
        
        self.input.didTapSignup
            .bind(to: self.output.showSignupScene)
            .disposed(by: self.disposeBag)
        
        self.input.didTapLogin
            .bind(onNext: { [weak self] (_) in
                guard let self = self else { return }
                let username = self.input.usernameEditingChanged.value
                let password = self.input.passwordEditingChanged.value
                let userToLogin = LoginUser(username: username, password: password)
                self.output.loginButtonEnabled.accept(false)
                worker.login(userToLogin: userToLogin) { (user) in
                    if user != nil {
                        self.output.showChatScene.accept(())
                    } else {
                        // show error
                        self.output.showError.accept("username or password incorrect")
                    }
                    self.output.loginButtonEnabled.accept(true)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension LoginViewModel {
    
    struct Input {
        var viewWillAppear = PublishRelay<()>()
        var didTapLogin = PublishRelay<()>()
        var didTapSignup = PublishRelay<()>()
        var usernameEditingChanged = BehaviorRelay<String>(value: "")
        var passwordEditingChanged = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        var showSignupScene = PublishRelay<()>()
        var showChatScene = PublishRelay<()>()
        var loginButtonEnabled = PublishRelay<Bool>()
        var showError = PublishRelay<String>()
    }
}
