//
//  UsersWorker.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/9/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class UsersWorker {
    let usersStore: UsersStore
    
    init(usersStore: UsersStore) {
        self.usersStore = usersStore
    }
    
    func getUser(userId: String, completion: @escaping (User?) -> Void) {
        self.usersStore.getUser(userId: userId, completion: completion)
    }
    
    func login(userToLogin: LoginUser, completion: @escaping (User?) -> Void) {
        self.usersStore.login(userToLogin: userToLogin, completion: completion)
    }
    
    func signup(userToSignup: SignupUser, completion: @escaping (User?) -> Void) {
        self.usersStore.signup(userToSignup: userToSignup, completion: completion)
    }
    
}

protocol UsersStore {
    func getUser(userId: String, completion: @escaping (User?) -> Void)
    func login(userToLogin: LoginUser, completion: @escaping (User?) -> Void)
    func signup(userToSignup: SignupUser, completion: @escaping (User?) -> Void)
}
