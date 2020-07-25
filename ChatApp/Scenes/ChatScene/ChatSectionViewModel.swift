//
//  ChatSectionViewModel.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/14/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct ChatSectionViewModel: Hashable {
    var id = UUID().uuidString
    var message: Message
    var items: [Item] = [.message, .user, .delivery]
    
    func getMessage() -> String {
        self.message.message
    }
    
    func getUsername() -> String {
        self.message.sender.username
    }
    
    func getDeliveryStatus() -> String {
        switch self.message.delivery {
        case .failed:
            return "Failed"
        case .sending:
            return "Sending"
        case .sent:
            return "Sent"
        case .none:
            return "Sent"
        }
    }
}

extension ChatSectionViewModel {
    
    enum Item: String {
        case message
        case user
        case delivery
        
        static func ==(lhs: Item, rhs: Item) -> Bool {
            return false
        }
    }
}
