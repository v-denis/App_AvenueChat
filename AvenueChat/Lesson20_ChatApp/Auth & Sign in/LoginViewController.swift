//
//  SignInViewController.swift
//  AvenueChat
//
//  Created by Влад Мади on 22.02.2020.
//  Copyright © 2020 Влад Мади. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	let welcomeLabel = UILabel(text: "Рады видеть тебя снова!", font: UIFont.appleSDGothicNeoBold30)
	let enterLabel = UILabel(text: "Войти с", font: UIFont.appleSDGothicNeo20)
	let orLabel = UILabel(text: "или", font: UIFont.appleSDGothicNeoBold22)
	let passwordLabel = UILabel(text: "Пароль", font: UIFont.appleSDGothicNeo20)
	let emailLabel = UILabel(text: "Email", font: UIFont.appleSDGothicNeo20)
	let registrationLabel = UILabel(text: "Нужен аккаунт?", font: .appleSDGothicNeo20)
	weak var delegate: AuthNavigationDelegate?
	
	let googleButton = UIButton(title: "Google", backgroundColor: .buttonLight, titleColor: .darkText, font: UIFont.appleSDGothicNeo26, cornerRadius: 6, isShadow: true)
	
	let loginButton = UIButton(title: "Войти", backgroundColor: .buttonDark, titleColor: .lightText, font: UIFont.appleSDGothicNeo26, cornerRadius: 6, isShadow: false)

	let registrationButton: UIButton = {
		let button = UIButton()
		button.setTitle("Регистрация", for: .normal)
		button.setTitleColor(.textRed, for: .normal)
		button.titleLabel?.font = UIFont.appleSDGothicNeoBold22
		return button
	}()
	
	let emailTextField = OneLineTextField(font: .appleSDGothicNeo26)
	let passwordTextField = OneLineTextField(font: .appleSDGothicNeo26)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConsraints()
		addTargets()
		emailTextField.text = (UserDefaultsDataManager.shared.isFirstLaunch) ? "" : UserDefaultsDataManager.shared.lastUserEmail
	}
	
}




//MARK: Setup Constraints

extension LoginViewController {
	
	private func setupConsraints() {
		view.backgroundColor = .white
		let enterFormView = ButtonFormView(label: enterLabel, button: googleButton)
		let emailStackView = UIStackView(arrangedViews: [emailLabel, emailTextField],
										 axis: .vertical,
										 spacing: 20)
		let passwordStackView = UIStackView(arrangedViews: [passwordLabel,passwordTextField],
											axis: .vertical,
											spacing: 20)
		
		let registrationStackView = UIStackView(arrangedViews: [registrationLabel,registrationButton], axis: .horizontal, spacing: 15)
		orLabel.textAlignment = .center
		let mainStackView = UIStackView(arrangedViews: [enterFormView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 29)
		
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		enterFormView.translatesAutoresizingMaskIntoConstraints = false
		emailStackView.translatesAutoresizingMaskIntoConstraints = false
		passwordStackView.translatesAutoresizingMaskIntoConstraints = false
		registrationStackView.translatesAutoresizingMaskIntoConstraints = false
		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(mainStackView)
		view.addSubview(registrationStackView)
		view.addSubview(welcomeLabel)
		
		NSLayoutConstraint.activate([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			mainStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 55),
			mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			registrationStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 30),
			registrationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}



//MARK: User actions
extension LoginViewController {
	
	func addTargets() {
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
		registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
	}
	
	
	@objc private func registrationButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.toSignUpViewController()
		}
	}
	
	@objc func loginButtonTapped() {
		guard let notEmptyEmail = emailTextField.text else { return }
		guard let notEmptyPassword = passwordTextField.text else { return }
		AuthService.shared.login(email: notEmptyEmail, password: notEmptyPassword) { (result) in
			switch result {
				
				case .success(let user):
					UserDefaultsDataManager.shared.saveLoggedInUserData(email: notEmptyEmail, password: notEmptyPassword)
					self.showAlert(title: "Поздравляем", message: "Вы авторизованы") { (_) in
						FireStoreService.shared.getUserData(askingUser: user) { (result) in
							switch result {
								
								case .success(let mwuser):
									self.present(TabBarViewController(currentUser: mwuser), animated: true, completion: nil)
								case .failure(_):
									self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
							}
						}
				}
				case .failure(_):
					self.showAlert(title: "Ошибка", message: "Авторизоваться не удалось!")
			}
		}
	}
	
	@objc func googleButtonTapped() {
		
	}
}







//MARK: representation UI in Canvas
import SwiftUI

struct LoginViewControllerProvider: PreviewProvider {
	
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		
		let viewController = LoginViewController()
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<LoginViewControllerProvider.ContainerView>) -> LoginViewController {
			return viewController
		}
		
		func updateUIViewController(_ uiViewController: LoginViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginViewControllerProvider.ContainerView>) {
		}
	}
}

