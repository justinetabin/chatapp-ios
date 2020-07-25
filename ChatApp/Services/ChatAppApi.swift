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

class ChatAppApi: UsersStore, ChatsStore {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl + "/api"
    }
    
    private func makeRequest<T: Codable>(of: T.Type, path: String, method: HTTPMethod = .get, params: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(self.baseUrl + path, method: method, parameters: params)
            .responseDecodable(of: of) { (response) in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getUser(userId: String, completion: @escaping (User?) -> Void) {
        self.makeRequest(of: User.self, path: "/users/\(userId)") { (result) in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func login(userToLogin: LoginUser, completion: @escaping (User?) -> Void) {
        let params = ["username": userToLogin.username,
                      "password": userToLogin.password]
        self.makeRequest(of: User.self, path: "/users/login", method: .post, params: params) { (result) in
            switch result {
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
        self.makeRequest(of: User.self, path: "/users/signup", method: .post, params: params) { (result) in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func getMessages(page: Page, completion: @escaping ([Message]?) -> Void) {
        self.makeRequest(of: [Message].self, path: "/messages?skip=\(page.skip)&limit=\(page.limit)") { (result) in
            switch result {
            case .success(let messages):
                completion(messages)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func createMessage(messageToCreate: CreateMessage, completion: @escaping (Message?) -> Void) {
        let params = ["message": messageToCreate.message, "localId": messageToCreate.localId, "senderId": messageToCreate.senderId]
        self.makeRequest(of: Message.self, path: "/messages", method: .post, params: params) { (result) in
            switch result {
            case .success(let message):
                completion(message)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
