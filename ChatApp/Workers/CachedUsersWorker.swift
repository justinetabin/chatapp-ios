//
//  CachedUsersWorker.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/15/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation


class CachedUsersWorker {
    let usersWorker: UsersWorker
    let cacheStore: CachedUsersStore
    
    init(usersWorker: UsersWorker, cacheStore: CachedUsersStore) {
        self.usersWorker = usersWorker
        self.cacheStore = cacheStore
    }
    
    func getUser(userId: String, completion: @escaping (User?) -> Void) {
        self.usersWorker.getUser(userId: userId, completion: completion)
    }
    
    func login(userToLogin: LoginUser, completion: @escaping (User?) -> Void) {
        self.usersWorker.login(userToLogin: userToLogin) { (user) in
            if let user = user {
                self.cacheStore.setLoggedInUser(user: user)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func signup(userToSignup: SignupUser, completion: @escaping (User?) -> Void) {
        self.usersWorker.signup(userToSignup: userToSignup) { (user) in
            if let user = user {
                self.cacheStore.setLoggedInUser(user: user)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func getLoggedInUser(completion: @escaping (User?) -> Void) {
        self.cacheStore.getLoggedInUser(completion: completion)
    }
    
    func removeLoggedInUser(completion: @escaping () -> Void ) {
        self.cacheStore.removeLoggedInUser(completion: completion)
    }
    
}

protocol CachedUsersStore {
    func setLoggedInUser(user: User)
    func getLoggedInUser(completion: @escaping (User?) -> Void)
    func removeLoggedInUser(completion: @escaping () -> Void)
}
