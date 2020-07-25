//
//  SignupViewModel.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/7/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SignupViewModel: BaseViewModel {
   
   var input = Input() 
   var output = Output()
    
    init(factory: WorkerFactory) {
        super.init()
        let usersWorker = factory.makeCachedUsersWorker()
        
        self.input.didTapLogin
            .bind(to: self.output.showLoginScene)
            .disposed(by: self.disposeBag)
        
        self.input.didTapSignup
            .bind { [weak self] _ in
                guard let self = self else { return }
                let username = self.input.usernameEditingChanged.value
                let password = self.input.passwordEditingChanged.value
                let userToSignup = SignupUser(username: username, password: password)
                self.output.signupEnabled.accept(false)
                usersWorker.signup(userToSignup: userToSignup) { (user) in
                    if let _ = user {
                        self.output.showChatScene.accept(())
                    } else {
                        self.output.showError.accept("username / password invalid")
                    }
                    self.output.signupEnabled.accept(true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}

extension SignupViewModel {
     
     struct Input {
        var didTapLogin = PublishRelay<()>()
        var didTapSignup = PublishRelay<()>()
        var usernameEditingChanged = BehaviorRelay<String>(value: "")
        var passwordEditingChanged = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        var showChatScene = PublishRelay<()>()
        var showLoginScene = PublishRelay<()>()
        var showError = PublishRelay<String>()
        var signupEnabled = PublishRelay<Bool>()
    }
}
