//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/9/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ChatViewModel: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    private var messages = [Message]()
    private var pagingLimit = 10
    private var currentUser: User?
    
    init(factory: WorkerFactory) {
        super.init()
        let chatsWorker = factory.makeChatsWorker()
        let usersWorker = factory.makeCachedUsersWorker()

        // listen to socket connectivity
        chatsWorker.onSocketStatus().bind { [weak self] (status) in
            guard let self = self else { return }
            switch status {
            case .error:
                self.output.showNotif.accept(("Disconnected", 0))
                
            case .connected:
                self.output.showNotif.accept(("Connected", 2))
                
                // fetch messages
                chatsWorker.listMessages(page: Page(skip: 0, limit: self.pagingLimit)) { (messages) in
                    if let messages = messages {
                        // got messages
                        self.messages = messages
                        self.output.messages.accept((messages, .initial))
                    } else {
                        // got no messages, connection error or server error
                    }
                }
            default: break
            }
        }.disposed(by: self.disposeBag)
        
        chatsWorker.onMessage().bind { [weak self] (gotMessage) in
            guard let self = self else { return }
            let contains = self.messages.contains(where: { $0.localId == gotMessage.localId })
            if contains == false {
                self.messages.append(gotMessage)
                self.output.messages.accept((self.messages, .incomingNew))
            }
        }.disposed(by: self.disposeBag)
                
        // view did load
        self.input.viewDidLoad
            .bind { [weak self] (_) in
                guard let self = self else { return }
                
                // hide paging indicator
                self.output.showPaginationIndicator.accept(true)
                
                // validate cached in user
                usersWorker.getLoggedInUser { (currentUser) in
                    if let currentUser = currentUser {
                        // validate user in api
                        usersWorker.getUser(userId: currentUser._id) { (gotUser) in
                            if let gotUser = gotUser {
                                // proceed to list messages
                                self.currentUser = gotUser
                                chatsWorker.socketConnect()
                            } else {
                                // user not found, proceed LoginScene
                                usersWorker.removeLoggedInUser {
                                    self.output.showLoginScene.accept(())
                                }
                            }
                        }
                    } else {
                        // no user, somehow bypassed checking on landing scene?
                    }
                }
            }.disposed(by: self.disposeBag)
        
        // did reach top
        self.input.didScrollToTop.bind { [weak self] (_) in
            guard let self = self else { return }
            let skip = self.messages.filter { $0.delivery == .sent || $0.delivery == .none }.count
            chatsWorker.listMessages(page: Page(skip: skip, limit: self.pagingLimit)) { (messages) in
                if let messages = messages {
                    // hide paginationIndicator
                    if messages.count < self.pagingLimit {
                        self.output.showPaginationIndicator.accept(false)
                    }
                    
                    // don't paginate if result count is < paging limit
                    if !messages.isEmpty {
                        self.messages.insert(contentsOf: messages, at: 0)
                        self.output.messages.accept((self.messages, .paging(count: messages.count)))
                    }
                } else {
                    // got no messages, connection error or server error
                }
            }
        }.disposed(by: self.disposeBag)
        
        // did tap logout
        self.input.didTapLogout.bind { [weak self] (_) in
            chatsWorker.socketDisconnect()
            usersWorker.removeLoggedInUser {
                self?.output.showLoginScene.accept(())
            }
        }.disposed(by: self.disposeBag)
        
        // did tap send message
        self.input.didTapSend.bind { [weak self] (_) in
            guard let self = self else { return }
            let messageValue = self.input.messageEditingChanged.value
            if let currentUser = self.currentUser {
                let senderId = currentUser._id
                let message = Message(_id: UUID().uuidString,
                                      localId: UUID().uuidString,
                                      message: messageValue,
                                      senderId: senderId,
                                      createdAt: "",
                                      updatedAt: "",
                                      sender: currentUser,
                                      delivery: .sending)
                self.messages.append(message)
                self.output.messages.accept((self.messages, .outgoingNew))
                let messageToCreate = CreateMessage(senderId: message.senderId, localId: message.localId, message: message.message)
                chatsWorker.sendMessage(messageToCreate: messageToCreate) { (gotMessage) in
                    if let index = self.messages.firstIndex(of: message) {
                        if let gotMessage = gotMessage {
                            self.messages[index] = gotMessage
                        } else {
                            self.messages[index].delivery = .failed
                        }
                        self.output.messages.accept((self.messages, .update))
                    }
                }
            }
        }.disposed(by: self.disposeBag)
    }
    
}

extension ChatViewModel {
    
    struct Input {
        var viewDidLoad = PublishRelay<()>()
        var messageEditingChanged = BehaviorRelay<String>(value: "")
        var didTapSend = PublishRelay<()>()
        var didScrollToTop = PublishRelay<()>()
        var didTapLogout = PublishRelay<()>()
    }
    
    struct Output {
        var messages = BehaviorRelay<([Message], State)>(value: ([], .initial))
        var scrollToBottom = PublishRelay<()>()
        var showPaginationIndicator = PublishRelay<Bool>()
        var showLoginScene = PublishRelay<()>()
        var outgoingNewMessage = PublishRelay<ChatSectionViewModel>()
        var showNotif = PublishRelay<(String, Int)>()
    }
    
    enum State {
        case initial
        case paging(count: Int)
        case outgoingNew
        case incomingNew
        case update
    }
}
