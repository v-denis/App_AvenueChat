//
//  ActiveChatViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 13.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

//MARK: - Current VC for request/first message to user. Presented on item select at PeopleViewController
class ActiveChatViewController: UIViewController {

	private let user: MWUser
	var userNameLabel = UILabel(text: "Вовочка Сидоров", font: UIFont.appleSDGothicNeoBold30)
	var userDescriptionLabel = UILabel(text: "Сначала был старостой, потом не был, потом снова был", font: UIFont.appleSDGothicNeo20, numberOfLines: 0)
	var avatarImageView = UIImageView(image: UIImage(named: "human5"), contentMode: .scaleAspectFill)
	var textFieldWithButton = TextFieldWithButton(backgroundColor: UIColor.buttonLight, font: UIFont.appleSDGothicNeo20, textColor: .black, buttonColor: UIColor.buttonLightBlue, borderWidth: 2, borderColor: UIColor.black.cgColor)
	var mainView = UIView(backgroundColor: UIColor.buttonLight.withAlphaComponent(0.9), cornerRadius: 20)
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		setupConstraints()
		textFieldWithButton.button.addTarget(self, action: #selector(textFieldButtonTapped), for: .touchUpInside)
    }
	
	@objc private func textFieldButtonTapped() {
		guard let message = textFieldWithButton.textField.text, !message.isEmpty else { return }
		self.dismiss(animated: true) {
			FireStoreService.shared.createWaitingChat(message: message, adresat: self.user) { (result) in
				switch result {
					case .success:
						UIApplication.getTopVC()?.showAlert(title: "Готово", message: "Ваше сообщение для \(self.user.username) отправлено")
					case .failure(let error):
						UIApplication.getTopVC()?.showAlert(title: "Ошибка", message: error.localizedDescription)
				}
			}
		}
	}
	
	init(user: MWUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
		title = user.username
		avatarImageView.sd_setImage(with: URL(string: user.avatarStringUrl), completed: nil)
		userNameLabel.text = user.username
		userDescriptionLabel.text = user.description
		
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


//MARK: - setup constraints
extension ActiveChatViewController {
	
	private func setupConstraints() {
		
		let mainStackView = UIStackView(arrangedViews: [userNameLabel, userDescriptionLabel, textFieldWithButton], axis: .vertical, spacing: 20)
		
		mainView.addSubview(mainStackView)
		Helper.tamicOff(for: [avatarImageView, mainStackView, mainView])
		Helper.addSubViews(superView: view, subViews: [avatarImageView, mainView])
		
		
		NSLayoutConstraint.activate([
			avatarImageView.topAnchor.constraint(equalTo: view.topAnchor),
			avatarImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		NSLayoutConstraint.activate([
			mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
			mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
			mainStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
			mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
			mainStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
		])
		
		
	}
}



