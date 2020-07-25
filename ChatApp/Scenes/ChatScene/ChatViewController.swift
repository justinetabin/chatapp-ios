//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/9/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ChatViewController: BaseViewController<ChatViewModel> {
    
    typealias DataSource = UICollectionViewDiffableDataSource<ChatSectionViewModel, ChatSectionViewModel.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ChatSectionViewModel, ChatSectionViewModel.Item>
    
    var chatInputView: ChatInputView = {
        let view = ChatInputView()
        return view
    }()
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var pagingActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    var newMessageIndicatorLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.padding.left = 8
        view.padding.right = 8
        view.padding.top = 5
        view.padding.bottom = 5
        view.text = "New Message"
        view.isUserInteractionEnabled = true
        view.isHidden = true
        view.backgroundColor = Colors.lightGray
        view.font = Fonts.medium()
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        return view
    }()
    
    var hamburgerView: HamburgerNotifView = {
        let view = HamburgerNotifView()
        return view
    }()
    
    var scrollAfterPaginate = false
    
    lazy var datasource: DataSource = {
        let datasource = DataSource(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.datasource.snapshot().sectionIdentifiers[indexPath.section]
            switch item {
            case .message:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCollectionCell.reuseIdentifier,
                                                              for: indexPath) as! ChatMessageCollectionCell
                cell.messageLabel.text = section.getMessage()
                return cell
                
            case .user:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageUserCollectionCell.reuseIdentifier,
                                                              for: indexPath) as! ChatMessageUserCollectionCell
                cell.nameLabel.text = section.getUsername()
                return cell
                
            case .delivery:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageDeliveryCollectionCell.reuseIdentifier,
                                                              for: indexPath) as! ChatMessageDeliveryCollectionCell
                cell.statusLabel.text = section.getDeliveryStatus()
                return cell
            }
        }
        return datasource
    }()
    
    fileprivate func applySnapshot(animated: Bool = false, completion: (() -> Void)? = nil) {
        // each cell view models can be considered
        let sections = self.viewModel.output.messages.value.0.map { ChatSectionViewModel(message: $0) }
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { (section) in
            snapshot.appendItems(section.items, toSection: section)
        }
        self.datasource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    override func keyboardWillShow(height: CGFloat) {
        self.chatInputView.snp.updateConstraints { (make) in
            make.bottomMargin.equalTo(-height)
        }
        self.chatInputView.layoutIfNeeded()
    }
    
    override func keyboardWillHide() {
        self.chatInputView.snp.updateConstraints { (make) in
            make.bottomMargin.equalTo(0)
        }
        self.chatInputView.layoutIfNeeded()
    }
    
    fileprivate func scrollToBottom(animated: Bool = false) {
        let sectionCount = self.datasource.snapshot().sectionIdentifiers.count - 1
        if sectionCount > 0 {
            let indexPath = IndexPath(item: 1, section: sectionCount)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
        }
    }
    
    fileprivate func bindViews() {
        // displayable messages
        self.viewModel.output.messages
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (messages, state) in
                guard let self = self else { return }
                self.applySnapshot {
                    switch state {
                    case .initial, .outgoingNew:
                        self.scrollToBottom()
                    case .paging(let count):
                        if self.scrollAfterPaginate {
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: count), at: .top, animated: false)
                        }
                    case .incomingNew:
                        self.newMessageIndicatorLabel.isHidden = false
                    default:
                        break
                    }
                }
        }.disposed(by: self.disposeBag)
        
        // notif view
        self.viewModel.output.showNotif
            .bind { (text, hidesAfter) in
                if text.isEmpty {
                    self.hamburgerView.hide()
                } else {
                    self.hamburgerView.show(text: text, hidesAfter: hidesAfter)
                }
            }.disposed(by: self.disposeBag)
        
        // new message label
        let tap = self.newMessageIndicatorLabel.gestureRecognizers?.first
        tap?.rx.event.bind { [weak self] _ in
            self?.newMessageIndicatorLabel.isHidden = true
            self?.scrollToBottom(animated: true)
        }.disposed(by: self.disposeBag)
        
        // scroll to bottom
        self.viewModel.output.scrollToBottom
            .bind { [weak self] (_) in
                self?.scrollToBottom()
        }.disposed(by: self.disposeBag)
        
        // show paging indicator
        self.viewModel.output.showPaginationIndicator.bind { [weak self] (show) in
            if show {
                self?.pagingActivityIndicator.startAnimating()
            } else {
                self?.pagingActivityIndicator.stopAnimating()
            }
        }.disposed(by: self.disposeBag)
        
        // logout button tap
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: self.viewModel.input.didTapLogout)
            .disposed(by: self.disposeBag)
        
        // show login scene
        self.viewModel.output.showLoginScene
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (_) in
                guard let self = self else { return }
                let vc = self.factory.makeLoginScene()
                self.navigationController?.setViewControllers([vc], animated: true)
            }.disposed(by: self.disposeBag)
        
        // send tapped
        self.chatInputView.sendButton.rx.tap
            .bind(to: self.viewModel.input.didTapSend)
            .disposed(by: self.disposeBag)
        
        // clear input text view
        self.chatInputView.sendButton.rx.tap
            .bind { [weak self] (_) in
                self?.chatInputView.messageTextView.text = ""
            }.disposed(by: self.disposeBag)
        
        // message input editing changed
        self.chatInputView.messageTextView.rx.text
            .map { $0 ?? "" }
            .bind(to: self.viewModel.input.messageEditingChanged)
            .disposed(by: self.disposeBag)
        
        // enabling send button
        self.chatInputView.messageTextView.rx.text
            .map { $0 != "" }
            .bind(to: self.chatInputView.sendButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func setupCollectionView() {
        // register collection cells
        self.collectionView.delegate = self
        self.collectionView.register(ChatMessageCollectionCell.self, forCellWithReuseIdentifier: ChatMessageCollectionCell.reuseIdentifier)
        self.collectionView.register(ChatMessageUserCollectionCell.self, forCellWithReuseIdentifier: ChatMessageUserCollectionCell.reuseIdentifier)
        self.collectionView.register(ChatMessageDeliveryCollectionCell.self, forCellWithReuseIdentifier: ChatMessageDeliveryCollectionCell.reuseIdentifier)
        
        // make an offset for paging activity indicator
        self.collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setupSubviews() {
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.collectionView)
        self.containerView.addSubview(self.chatInputView)
        self.containerView.addSubview(self.newMessageIndicatorLabel)
        self.collectionView.addSubview(self.pagingActivityIndicator)
        
        // container view
        self.containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // hamburger view
        self.hamburgerView.attachIn(view: self.containerView)
        
        // input view constraints
        self.chatInputView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
        
        // new message indicator
        self.newMessageIndicatorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.chatInputView).offset(10)
            make.bottom.equalTo(self.chatInputView.snp.top)
        }
        
        // collection view constraints
        self.collectionView.snp.makeConstraints { (make) in
            make.leftMargin.top.rightMargin.equalToSuperview()
            make.bottom.equalTo(self.chatInputView.snp.top)
        }
        
        // paging activity indicator
        self.pagingActivityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.collectionView)
            make.top.equalTo(self.collectionView).offset(-20)
        }
    }
    
    fileprivate func setupNav() {
        // logout button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupCollectionView()
        self.setupNav()
        self.bindViews()
        self.viewModel.input.viewDidLoad.accept(())
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollAfterPaginate = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let topInset = scrollView.contentInset.top
        let topMargin = scrollView.safeAreaInsets.top
        let topOffset = scrollView.contentOffset.y + topInset + topMargin
        if topOffset <= 0 {
            self.scrollAfterPaginate = true
            self.viewModel.input.didScrollToTop.accept(())
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.newMessageIndicatorLabel.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = self.datasource.itemIdentifier(for: indexPath) else { return .zero }
        let section = self.datasource.snapshot().sectionIdentifiers[indexPath.section]
        let fixedWidth = collectionView.frame.width
        
        switch item {
        case .message:
            let message = section.getMessage()
            let calculatedWidth = fixedWidth - 40 // left, right insets
            let calculatedHeight = message.heightWithConstrainedWidth(calculatedWidth,
                                                                      font: Fonts.medium(weight: .light)) ?? 0
            return CGSize(width: fixedWidth, height: calculatedHeight)
            
        case .user, .delivery:
            return CGSize(width: fixedWidth, height: 20)
        }
    }
}
