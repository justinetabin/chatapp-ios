//
//  ChatMessageDeliveryCollectionCell.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageDeliveryCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier = "ChatMessageDeliveryCollectionCell"
    
    var statusLabel: UILabel = {
        let view = UILabel()
        view.text = "Sent"
        view.font = Fonts.small()
        return view
    }()

    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.statusLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        self.statusLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
