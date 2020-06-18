//
//  ViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
	
	let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"), contentMode: .scaleAspectFit)
	
	let googleLabel = UILabel(text: "Регистрация с", font: .appleSDGothicNeo24)
	let googleButton = UIButton(title: "Google", backgroundColor: .buttonLight, titleColor: .buttonDark, font: .appleSDGothicNeo20, isShadow: true)
	
	let emaiLabel = UILabel(text: "или с помощью", font: .appleSDGothicNeo24)
	let emailButton = UIButton(title: "Email", backgroundColor: .buttonDark, titleColor: .buttonLight, font: .appleSDGothicNeo20, isShadow: false)
	
	let loginLabel = UILabel(text: "или вы уже с нами", font: .appleSDGothicNeo24)
	let loginButton = UIButton(title: "Войти", backgroundColor: .buttonLight, titleColor: .textBlue, font: .appleSDGothicNeoBold20, isShadow: true)
	
	var googleButtonFormView: ButtonFormView?
	var emailButtonFormView: ButtonFormView?
	var loginButtonFormView: ButtonFormView?
	
	let loginVC = LoginViewController()
	let signUpVC = SignUpViewController()
	

	override func viewDidLoad() {
		super.viewDidLoad()
		print("First launch: ", UserDefaultsDataManager.shared.isFirstLaunch)
		setupConstraints()
		addTargets()
		loginVC.delegate = self
		signUpVC.delegate = self
	}


}


//MARK: Setup constraints

extension AuthViewController {
	
	private func setupConstraints() {
		
		googleButtonFormView = ButtonFormView(label: googleLabel, button: googleButton)
		emailButtonFormView = ButtonFormView(label: emaiLabel, button: emailButton)
		loginButtonFormView = ButtonFormView(label: loginLabel, button: loginButton)
		
		let stackView = UIStackView(arrangedViews: [googleButtonFormView!,
												emailButtonFormView!,
												loginButtonFormView!], axis: .vertical, spacing: 40)
		
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		
		view.addSubview(logoImageView)
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
			logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			logoImageView.widthAnchor.constraint(equalToConstant: 250),
			logoImageView.heightAnchor.constraint(equalToConstant: 50)
		])
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 90),
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
		
		
		])

	}
}


//MARK: User actions
extension AuthViewController {
	
	func addTargets() {
		emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
	}
	
	
	@objc func loginButtonTapped() {
		present(loginVC, animated: true, completion: nil)
	}
	
	@objc func emailButtonTapped() {
		present(signUpVC, animated: true, completion: nil)
	}
	
	@objc func googleButtonTapped() {
	}
}


extension AuthViewController: AuthNavigationDelegate {
	
	func toLoginViewController() {
		self.present(loginVC, animated: true, completion: nil)
	}
	
	func toSignUpViewController() {
		self.present(signUpVC, animated: true, completion: nil)
	}
	
	
}









//MARK: representation UI in Canvas
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
	
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	
	struct ContainerView: UIViewControllerRepresentable {
		
		
		let VC = AuthViewController()
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) -> AuthViewController {
			return VC
		}
		
		func updateUIViewController(_ uiViewController: AuthViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) {
		}
		
	}
	
	
}
