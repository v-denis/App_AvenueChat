//
//  SetupProfileViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import Firebase

class SetupProfileViewController: UIViewController {
	
	let profileSettingsLabel = UILabel(text: "Настройки профиля", font: UIFont.appleSDGothicNeoBold30)
	let nameLabel = UILabel(text: "Имя", font: UIFont.appleSDGothicNeo20)
	let aboutMeLabel = UILabel(text: "Обо мне", font: UIFont.appleSDGothicNeo20)
	let genderLabel = UILabel(text: "Пол", font: UIFont.appleSDGothicNeo20)
	
	let enterChatButton = UIButton(title: "Сохранить", backgroundColor: .buttonDark, titleColor: .textWhite, font: UIFont.appleSDGothicNeo20, cornerRadius: 6, isShadow: false)
	let photoView = AddPhotoView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	
	let genderSegmentControl = UISegmentedControl(left: "М", right: "Ж")
	
	let nameTextField = OneLineTextField(font: UIFont.appleSDGothicNeo26)
	let aboutMeTextField = OneLineTextField(font: UIFont.appleSDGothicNeo26)
	
	private let currentUser: User
	
	init(currentUser: User) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		UserDefaultsDataManager.shared.isFirstLaunch = false
		setupConstraints()
		tryToLoadUserData()
		enterChatButton.addTarget(self, action: #selector(enterChatAction), for: .touchUpInside)
		photoView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
	}
	
	private func tryToLoadUserData() {
		FireStoreService.shared.getUserData(askingUser: currentUser) { (result) in
			switch result {
				case .success(let mwuser):
					self.nameTextField.text = mwuser.username
					self.aboutMeTextField.text = mwuser.description
					if mwuser.gender == self.genderSegmentControl.titleForSegment(at: 0) {
						self.genderSegmentControl.selectedSegmentIndex = 0
					} else {
						self.genderSegmentControl.selectedSegmentIndex = 1
					}
					self.photoView.circleImageView.sd_setImage(with: URL(string: mwuser.avatarStringUrl), completed: nil)
					
				case .failure(_):
					break
			}
		}
	}
	
	@objc private func plusButtonTapped() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
		present(imagePickerController, animated: true, completion: nil)
	}
    
	@objc private func enterChatAction() {
		FireStoreService.shared.saveProfile(
			id: currentUser.uid,
			email: currentUser.email!,
			userName: nameTextField.text!,
			avatarImage: photoView.circleImageView.image!,
			description: aboutMeTextField.text!,
			gender: genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex)!) { (result) in
				
				switch result {
					case .success(let mwuser):
						self.showAlert(title: "Готово", message: "Данные сохранены!") { (_) in
							self.present(TabBarViewController(currentUser: mwuser), animated: true, completion: nil)
					}
					case .failure(_):
						self.showAlert(title: "Ошибка", message: "Не удалось сохранить данные")
				}
		}
		
	}
	
}


//MARK: - setup constraints
extension SetupProfileViewController {
	
	private func setupConstraints() {
		
		let nameStackView = UIStackView(arrangedViews: [nameLabel, nameTextField], axis: .vertical, spacing: 0)
		let aboutMeStackView = UIStackView(arrangedViews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
		let genderStackView = UIStackView(arrangedViews: [genderLabel, genderSegmentControl], axis: .vertical, spacing: 0)
		
		let mainStackView = UIStackView(arrangedViews: [nameStackView,aboutMeStackView,genderStackView, enterChatButton], axis: .vertical, spacing: 45)
		

		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		profileSettingsLabel.translatesAutoresizingMaskIntoConstraints = false
		photoView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(photoView)
		view.addSubview(mainStackView)
		view.addSubview(profileSettingsLabel)
		
		NSLayoutConstraint.activate([
			profileSettingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			profileSettingsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
		])
		
		NSLayoutConstraint.activate([
			photoView.topAnchor.constraint(equalTo: profileSettingsLabel.bottomAnchor, constant: 25),
			photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			mainStackView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 50),
			mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
		])
		
	}
}


//MARK: - select image from standart device library
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		
		photoView.circleImageView.image = image
	}
	
}

