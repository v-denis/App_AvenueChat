//
//  ChatViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 02.04.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

//MARK: - This VC will be presented between users messaging/chating
class ChatViewController: MessagesViewController {

	private let user: MWUser
	private let chat: Chat
	private var messages: [MWMessage] = []
	private var messageListener: ListenerRegistration?
	
	init(user: MWUser, chat: Chat) {
		self.user = user
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
		
		title = chat.friendUsername
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		messageListener?.remove()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		messagesCollectionView.messagesDataSource = self
		messageInputBar.delegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		configuratingMessageInputBar()
		creatingMessageListener()
    }
	
	func addMessage(message: MWMessage) {
		guard !messages.contains(message) else { return }
		messages.append(message)
		messages.sort()
		messagesCollectionView.reloadData()
	}
	
	func creatingMessageListener() {
		messageListener = ListenerService.shared.messageObserve(chat: chat, completion: { (result) in
			switch result {
				
				case .success(let message):
					self.addMessage(message: message)
				case .failure(let error):
					self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		})
	}
	
	
	func configuratingMessageInputBar() {
		messageInputBar.isTranslucent = true
		messageInputBar.separatorLine.isHidden = true
		messageInputBar.backgroundColor = .buttonLight
		messageInputBar.inputTextView.backgroundColor = .white
		messageInputBar.inputTextView.placeholder = "Введите текст сообщения"
		messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		messageInputBar.inputTextView.layer.cornerRadius = 18
		messageInputBar.inputTextView.layer.borderWidth = 0.5
		messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		messageInputBar.inputTextView.layer.masksToBounds = true
		messageInputBar.layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		messageInputBar.layer.shadowOpacity = 0.5
		messageInputBar.layer.shadowOffset = CGSize(width: 3, height: 0)
		messageInputBar.layer.shadowRadius = 4
		configuratingSendButton()
	}
	
	func configuratingSendButton() {
		messageInputBar.setRightStackViewWidthConstant(to: 80, animated: false)
		messageInputBar.sendButton.setTitle("", for: .normal)
		messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 5, right: 30)
		messageInputBar.sendButton.setSize(CGSize(width: 60, height: 60), animated: false)
	}

}

//MARK: - Configurating UI of messages representation
extension ChatViewController: MessagesDataSource {
	
	func currentSender() -> SenderType {
		return Sender(senderId: user.uid, displayName: user.username)
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.item]
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}
	
	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
}

//MARK: - Creating message and send to user to user
extension ChatViewController: InputBarAccessoryViewDelegate {
	
	//Called when the default send button has been selected
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let message = MWMessage(user: user, content: text)
		FireStoreService.shared.send(
			chat: chat,
			message: message) { (result) in
				switch result {
					
					case .success:
						self.messagesCollectionView.scrollToBottom()
					case .failure(let error):
						self.showAlert(title: "Ошибка", message: error.localizedDescription)
				}
		}
		inputBar.inputTextView.text = ""
	}
}


//MARK: - Configurating UI and elements of current VC presentation
extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {
	
	func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.4638805651) : #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.1876337757)
	}
	
	func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	}
	
	func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return CGSize(width: 100, height: 40)
	}
	
	func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return CGSize(width: 50, height: 50)
	}
	
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		return .bubbleOutline(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
	}
	
	func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		avatarView.isHidden = false
		if isFromCurrentSender(message: message) {
			avatarView.sd_setImage(with: URL(string: user.avatarStringUrl), completed: nil)
		} else {
			avatarView.sd_setImage(with: URL(string: chat.friendImageString), completed: nil)
		}
	}
}
