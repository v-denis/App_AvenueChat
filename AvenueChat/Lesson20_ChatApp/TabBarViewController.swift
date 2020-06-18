//
//  TabBarViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
	
	private let currentUser: MWUser
	
	init(currentUser: MWUser = MWUser(email: "Default email",
									  username: "Default name",
									  uid: "defaultID",
									  avatarStringUrl: "",
									  description: "Default description",
									  gender: "Default gender"))
	{
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.modalPresentationStyle = .fullScreen
		UserDefaultsDataManager.shared.isFirstLaunch = false
		let listVC = ListViewController(currentUser: currentUser)
		let peopleVC = PeopleViewController(currentUser: currentUser)
		
		let peopleImage = UIImage(systemName: "person.3", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
		let listImage = UIImage(systemName: "bubble.left", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
		
		tabBar.tintColor = .textBlue
		
		viewControllers = [
			generateViewController(rootVC: listVC, title: "Сообщения", image: listImage),
			generateViewController(rootVC: peopleVC, title: "Контакты", image: peopleImage),
		]
	
	}
	
	
	private func generateViewController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
		let navVC = UINavigationController(rootViewController: rootVC)
		navVC.tabBarItem.title = title
		navVC.tabBarItem.image = image
		return navVC
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
