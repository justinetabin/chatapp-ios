//
//  HamburgerNotifView.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/24/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class HamburgerNotifView: UIView {
    
    private var timer: Timer?
    private var topOffset: Int = 15
    
    private var notifLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.text = "This is a notif."
        view.numberOfLines = 0
        view.textColor = .white
        view.textAlignment = .center
        view.backgroundColor = Colors.lightGray
        view.padding = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.addSubview(self.notifLabel)
        
        self.notifLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            make.top.equalToSuperview().offset(-200)
        }
    }
    
    func attachIn(view: UIView) {
        view.addSubview(self)
        
        self.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
    }
    
    func show(text: String, hidesAfter: Int = 0) {
        self.timer?.invalidate()
        if hidesAfter > 0 {
            self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(hidesAfter), repeats: false, block: { [weak self] (_) in
                self?.timer = nil
                self?.hide()
            })
        }
        
        // dispatch immediately so it doesn't animate
        DispatchQueue.main.async {
            self.notifLabel.text = text
            self.isHidden = false
        }
        
        // animate constraints
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.notifLabel.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(self.topOffset)
            }
            self.layoutIfNeeded()
        }) { _ in }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.notifLabel.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(-100)
            }
            self.layoutIfNeeded()
        }) { _ in
            // this prevents shown, and empty notif
            if self.timer == nil {
                self.notifLabel.text = ""
                self.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
