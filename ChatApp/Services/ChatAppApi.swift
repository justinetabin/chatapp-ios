//
//  ChatAppApi.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ChatAppApi {
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func login(userToLogin: LoginUser, completion: @escaping (User?) -> Void) {
        let params = ["username": userToLogin.username,
                      "password": userToLogin.password]
        AF.request(self.baseUrl + "/login", method: .post, parameters: params)
            .responseDecodable(of: User.self) { (response) in
                switch response.result {
                case .success(let user):
                    completion(user)
                case .failure(_):
                    completion(nil)
                }
        }
    }
    
    func signup(userToSignup: SignupUser, completion: @escaping (User?) -> Void) {
        let params = ["username": userToSignup.username,
                      "password": userToSignup.password]
        AF.request(self.baseUrl + "/signup", method: .post, parameters: params)
            .responseDecodable(of: User.self) { (response) in
                switch response.result {
                case .success(let user):
                    completion(user)
                case .failure(_):
                    completion(nil)
                }
        }
    }
    
    func getMessages(page: Page, completion: @escaping ([Message]?) -> Void) {
        AF.request(self.baseUrl + "/messages?skip=\(page.skip)&limit=\(page.limit)", method: .get)
            .responseDecodable(of: [Message].self) { (response) in
                switch response.result {
                case .success(let messages):
                    completion(messages)
                case .failure(_):
                    completion(nil)
                }
        }
    }
    
    func createMessage(messageToCreate: CreateMessage, completion: @escaping (Message?) -> Void) {
        let params = ["message": messageToCreate.message, "localId": messageToCreate.localId, "senderId": messageToCreate.senderId]
        AF.request(self.baseUrl + "/messages", method: .post, parameters: params)
            .responseDecodable(of: Message.self) { (response) in
                switch response.result {
                case .success(let message):
                    completion(message)
                case .failure(_):
                    completion(nil)
                }
        }
    }
}
