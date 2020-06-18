//
//  VerificationChatViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 13.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

//MARK: - present current VC when you open chating request / first message. Called from ListViewController
class ConfirmChatViewController: UIViewController {

	let avatarImageView = UIImageView(image: UIImage(named: "human5"), contentMode: .scaleAspectFill)
	let mainView = UIView(backgroundColor: UIColor.buttonLight.withAlphaComponent(0.7), cornerRadius: 20)
	let acceptButton = UIButton(title: "Принять", backgroundColor: .buttonGreen, titleColor: .buttonDark, font: UIFont.appleSDGothicNeoBold30, cornerRadius: 10, isShadow: true)
	let declineButton = UIButton(title: "Отклонить", backgroundColor: .buttonRed, titleColor: .buttonDark, font: UIFont.appleSDGothicNeoBold30, cornerRadius: 10, isShadow: true)
	private var chat: Chat
	var delegate: WaitNavigationProtocol?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
		acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
		declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
	
	
	init(chat: Chat) {
		self.chat = chat
		avatarImageView.sd_setImage(with: URL(string: chat.friendImageString), completed: nil)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	@objc private func acceptButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.activateChat(chat: self.chat)
		}
	}
	
	@objc private func declineButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.removeChat(chat: self.chat)
		}
	}
	
	
	private func setupConstraints() {
		
		let buttonsStackView = UIStackView(arrangedViews: [acceptButton, declineButton], axis: .vertical, spacing: 30)
		mainView.addSubview(buttonsStackView)
		Helper.tamicOff(for: [avatarImageView, mainView, buttonsStackView])
		Helper.addSubViews(superView: view, subViews: [avatarImageView, mainView])
		
		NSLayoutConstraint.activate([
			avatarImageView.topAnchor.constraint(equalTo: view.topAnchor),
			avatarImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		NSLayoutConstraint.activate([
			mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
		])
		
		NSLayoutConstraint.activate([
			buttonsStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
			buttonsStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 25),
			buttonsStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
			buttonsStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 30)
		])
	}

}

