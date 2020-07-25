//
//  DependencyWorker.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol WorkerFactory: class {
    func makeUsersWorker() -> UsersWorker
    func makeCachedUsersWorker() -> CachedUsersWorker
    func makeChatsWorker() -> ChatsWorker
}

protocol ViewControllerFactory: class {
    func makeLoginScene() -> LoginViewController
    func makeSignupScene() -> SignupViewController
    func makeChatScene() -> ChatViewController
}

class DependencyWorker {
    let chatsApi: ChatAppApi
    let chatsSocket: ChatAppSocket
    let usersDefaultsStore: UsersDefaultsStore
    
    init() {
        self.chatsApi = ChatAppApi(baseUrl: API.baseURL)
        self.chatsSocket = ChatAppSocket(baseUrl: API.baseURL)
        self.usersDefaultsStore = UsersDefaultsStore()
    }
}

extension DependencyWorker: WorkerFactory {
    
    func makeUsersWorker() -> UsersWorker {
        UsersWorker(usersStore: self.chatsApi)
    }
    
    func makeCachedUsersWorker() -> CachedUsersWorker {
        CachedUsersWorker(usersWorker: self.makeUsersWorker(),
                          cacheStore: self.usersDefaultsStore)
    }
    
    func makeChatsWorker() -> ChatsWorker {
        ChatsWorker(chatsStore: self.chatsApi, chatsSocket: self.chatsSocket)
    }
}

extension DependencyWorker: ViewControllerFactory {
    
    func makeLoginScene() -> LoginViewController {
        LoginViewController(factory: self, viewModel: LoginViewModel(factory: self))
    }
    
    func makeSignupScene() -> SignupViewController {
        SignupViewController(factory: self, viewModel: SignupViewModel(factory: self))
    }
    
    func makeChatScene() -> ChatViewController {
        ChatViewController(factory: self, viewModel: ChatViewModel(factory: self))
    }
}
