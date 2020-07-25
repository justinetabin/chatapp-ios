//
//  ChatAppSocket.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/18/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import SocketIO
import RxRelay

class ChatAppSocket {
    var manager: SocketManager
    var defaultSocket: SocketIOClient
    
    var onSocketStatus = BehaviorRelay<Status>(value: .initial)
    var onMessage = PublishRelay<Message>()
    
    init(baseUrl: String) {
        self.manager = SocketManager(socketURL: URL(string: baseUrl)!)
        self.defaultSocket = self.manager.defaultSocket
        
        // on connect
        self.defaultSocket.on(clientEvent: .connect) { (_, _) in
            self.onSocketStatus.accept(.connected)
        }
        
        // on disconnect
        self.defaultSocket.on(clientEvent: .disconnect) { (_, _) in
            self.onSocketStatus.accept(.disconnected)
        }
        
        // on error
        self.defaultSocket.on(clientEvent: .error) { (_, _) in
            self.onSocketStatus.accept(.error)
        }
        
        // on message
        self.defaultSocket.on(Event.message.rawValue) { (data, ack) in
            if let data = data.first as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                    let message = try JSONDecoder().decode(Message.self, from: jsonData)
                    self.onMessage.accept(message)
                } catch let error {
                    print("Something went wrong deserializing \(error)")
                }
                
            }
        }
    }
    
    func connect() {
        self.defaultSocket.connect()
    }
    
    func disconnect() {
        self.defaultSocket.disconnect()
    }
}

extension ChatAppSocket {
    
    enum Event: String {
        case message
    }
    
    enum Status {
        case initial
        case connected
        case disconnected
        case error
    }
}
