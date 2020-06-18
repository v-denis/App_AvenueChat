//
//  SignUpViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
	
	weak var delegate: AuthNavigationDelegate?
	let welcomeLabel = UILabel(text: "Рады видеть тебя!", font: UIFont.appleSDGothicNeoBold30)
	let emailLabel = UILabel(text: "Введите Email", font: UIFont.appleSDGothicNeo20)
	let passwordLabel = UILabel(text: "Введите пароль", font: UIFont.appleSDGothicNeo20)
	let confirmPasswordLabel = UILabel(text: "Повторите пароль", font: UIFont.appleSDGothicNeo20)
	let alreadyLabel = UILabel(text: "Уже с нами?", font: UIFont.appleSDGothicNeo20)
	
	let emailTextField = OneLineTextField(font: UIFont.appleSDGothicNeo24)
	let passwordTextField = OneLineTextField(font: UIFont.appleSDGothicNeo24)
	let confirmPasswordTextField = OneLineTextField(font: UIFont.appleSDGothicNeo24)
	
	let signUpButton = UIButton(title: "Регистрация", backgroundColor: UIColor.buttonDark, titleColor: UIColor.lightText, font: UIFont.appleSDGothicNeo24, cornerRadius: 6, isShadow: false)
	let loginButton: UIButton = {
		let button = UIButton()
		button.setTitle("Войти", for: .normal)
		button.setTitleColor(UIColor.textBlue, for: .normal)
		button.titleLabel?.font = UIFont.appleSDGothicNeoBold22
		return button
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.buttonLight
		setupConstraints()
		addTargets()
    }
    

}



//MARK: Setup constraints

extension SignUpViewController {
	
	private func setupConstraints() {
		
		let emailStackView = UIStackView(arrangedViews: [emailLabel,emailTextField],
										 axis: .vertical,
										 spacing: 0)
		let passwordStackView = UIStackView(arrangedViews: [passwordLabel,passwordTextField],
											axis: .vertical,
											spacing: 0)
		let confirmPasswordStackView = UIStackView(arrangedViews: [confirmPasswordLabel,confirmPasswordTextField],
												   axis: .vertical,
												   spacing: 0)
		
		signUpButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
		
		let stackView = UIStackView(arrangedViews: [emailStackView,passwordStackView,confirmPasswordStackView,signUpButton], axis: .vertical, spacing: 60)
	
		let buttonStackView = UIStackView(arrangedViews: [alreadyLabel, loginButton], axis: .horizontal, spacing: 25)
		
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(buttonStackView)
		
		NSLayoutConstraint.activate([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 70),
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
		])
		
		NSLayoutConstraint.activate([
			buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
			buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}




//MARK: User actions
extension SignUpViewController {
	
	func addTargets() {
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
	}
	
	
	@objc private func loginButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.toLoginViewController()
		}
	}
	
	
	@objc func signUpButtonTapped() {
		guard Helper.isFilled(fields: [emailTextField.text, passwordTextField.text]) else { return }
		AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
			switch result {
				case .success(let user):
					UserDefaultsDataManager.shared.saveLoggedInUserData(email: self.emailTextField.text!, password: self.passwordTextField.text!)
					self.showAlert(title: "Поздравялем!", message: "Регистрация прошла успешно") {(action) in
						self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
						}
				case .failure(_):
					self.showAlert(title: "Ошибка!", message: "Некорректно заполнены данные")
			}
		}
		
	}
	
}





//MARK: representation UI in Canvas
import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider {
	
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	
	struct ContainerView: UIViewControllerRepresentable {
		
		let VC = SignUpViewController()
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpViewControllerProvider.ContainerView>) -> SignUpViewController {
			return VC
		}
		
		func updateUIViewController(_ uiViewController: SignUpViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpViewControllerProvider.ContainerView>) {
		}
		
	}
	
	
}
