//
//  BaseViewController.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/6/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    let factory: ViewControllerFactory
    let viewModel: ViewModel
    let disposeBag = DisposeBag()
    let keyboardDismissTap = UITapGestureRecognizer()
    
    fileprivate func setupDismissKeyboard() {
        self.keyboardDismissTap.rx.event.bind { [weak self] (tap) in
            self?.view.endEditing(true)
        }.disposed(by: self.disposeBag)
        self.keyboardDismissTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(self.keyboardDismissTap)
    }
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyBoardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyBoardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyBoardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func keyboardWillShow(height: CGFloat) { }
    
    func keyboardDidShow(height: CGFloat) { }
    
    func keyboardWillHide() { }
    
    func keyboardDidHide() { }
    
    @objc fileprivate func _keyBoardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - view.layoutMargins.bottom
            self.keyboardWillShow(height: keyboardHeight)
        }
    }
    
    @objc fileprivate func _keyboardDidShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardDidShow(height: keyboardHeight)
        }
    }

    @objc fileprivate func _keyBoardWillHide(notification: NSNotification) {
        self.keyboardWillHide()
    }
    
    @objc fileprivate func _keyBoardDidHide(notification: NSNotification) {
        self.keyboardDidHide()
    }
    
    init(factory: ViewControllerFactory, viewModel: ViewModel) {
        self.factory = factory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.systemBackground
        self.setupKeyboardObservers()
        self.setupDismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
