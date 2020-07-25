//
//  User.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    var _id: String
    var username: String
    var password: String?
    var createdAt: String
    var updatedAt: String
}
