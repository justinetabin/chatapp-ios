//
//  UsersDefaultsStore.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/15/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class UsersDefaultsStore: CachedUsersStore {
    static let loggedInUserKey = "loggedInUserKey"
    
    let defaults: UserDefaults
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    func setLoggedInUser(user: User) {
        self.defaults.set(try? PropertyListEncoder().encode(user), forKey: UsersDefaultsStore.loggedInUserKey)
    }
    
    func getLoggedInUser(completion: @escaping (User?) -> Void) {
        if let data = self.defaults.value(forKey: UsersDefaultsStore.loggedInUserKey) as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            completion(user)
        } else {
            completion(nil)
        }
    }
    
    func removeLoggedInUser(completion: @escaping () -> Void) {
        self.defaults.set(nil, forKey: UsersDefaultsStore.loggedInUserKey)
        completion()
    }
}
