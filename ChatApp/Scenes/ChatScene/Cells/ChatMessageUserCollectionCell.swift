//
//  ChatMessageUserCollectionCell.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageUserCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier = "ChatMessageUserCollectionCell"
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Juan"
        view.font = Fonts.small(weight: .semibold)
        return view
    }()

    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.nameLabel)
        
        self.containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
