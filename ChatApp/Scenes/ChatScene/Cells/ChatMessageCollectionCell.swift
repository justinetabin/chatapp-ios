//
//  ChatMessageCollectionCell.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier = "ChatMessageCollectionCell"
        
    var messageLabel: UILabel = {
        let view = UILabel()
        view.text = "This is a message"
        view.font = Fonts.medium(weight: .light)
        view.numberOfLines = 0
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.messageLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
