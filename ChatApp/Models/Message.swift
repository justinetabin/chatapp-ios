//
//  Message.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct Message: Codable {
    var _id: String
    var localId: String
    var message: String
    var senderId: String
    var createdAt: String
    var updatedAt: String
    var sender: User
}

