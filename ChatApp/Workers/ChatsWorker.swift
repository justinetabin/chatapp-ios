//
//  ChatsWorker.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxRelay

class ChatsWorker {
    let chatsStore: ChatsStore
    let chatsSocket: ChatAppSocket
    
    init(chatsStore: ChatsStore, chatsSocket: ChatAppSocket) {
        self.chatsStore = chatsStore
        self.chatsSocket = chatsSocket
    }
    
    func listMessages(page: Page, completion: @escaping ([Message]?) -> Void) {
        self.chatsStore.getMessages(page: page, completion: completion)
    }
    
    func sendMessage(messageToCreate: CreateMessage, completion: @escaping (Message?) -> Void) {
        self.chatsStore.createMessage(messageToCreate: messageToCreate, completion: completion)
    }
    
    func onMessage() -> PublishRelay<Message> {
        return self.chatsSocket.onMessage
    }
    
    func onSocketStatus() -> BehaviorRelay<ChatAppSocket.Status> {
        return self.chatsSocket.onSocketStatus
    }
    
    func socketConnect() {
        self.chatsSocket.connect()
    }
    
    func socketDisconnect() {
        self.chatsSocket.disconnect()
    }
}

protocol ChatsStore {
    func getMessages(page: Page, completion: @escaping ([Message]?) -> Void)
    func createMessage(messageToCreate: CreateMessage, completion: @escaping (Message?) -> Void)
}
