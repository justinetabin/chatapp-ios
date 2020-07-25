//
//  ChatInputView.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import GrowingTextView

class ChatInputView: UIView {
    
    var messageTextView: GrowingTextView = {
        let view = GrowingTextView()
        view.placeholder = "Send a message"
        view.backgroundColor = Colors.lightGray
        view.font = Fonts.medium()
        view.textContainerInset.left = 5
        view.textContainerInset.right = 5
        view.layer.cornerRadius = 8
        view.maxHeight = 200
        return view
    }()
    
    var sendButton: UIButton = {
        let view = UIButton(type: .system)
        view.titleLabel?.font = Fonts.medium()
        view.setTitle("Send", for: .normal)
        view.isEnabled = false
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.sendButton)
        self.containerView.addSubview(self.messageTextView)
        
        // container view constraints
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // message text view constraints
        self.messageTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalTo(self.sendButton.snp.left).inset(-10)
        }
        
        // send button constraints
        self.sendButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(13)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
