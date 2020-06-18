//
//  UserDefaultsDataManager.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 01.04.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

final class UserDefaultsDataManager {
	
	private enum DefaultsUserKeys: String {
		case email
		case password
		case firstLaunch
	}
	
	static let shared = UserDefaultsDataManager()
	
	var isFirstLaunch: Bool {
		get {
			UserDefaults.standard.bool(forKey: DefaultsUserKeys.firstLaunch.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: DefaultsUserKeys.firstLaunch.rawValue)
		}
	}
	
	var lastUserEmail: String {
		get {
			UserDefaults.standard.string(forKey: DefaultsUserKeys.email.rawValue) ?? ""
		}
		set {
			UserDefaults.standard.set(newValue, forKey: DefaultsUserKeys.email.rawValue)
		}
	}
	
	internal func saveLoggedInUserData(email: String, password: String) {
		self.lastUserEmail = email
		UserDefaults.standard.set(password, forKey: email)
	}
	
	internal func getLoggedInUserData() -> (email: String, password: String)? {
		let email = self.lastUserEmail
		guard let password = UserDefaults.standard.string(forKey: email) else { return nil }
		return (email: email, password: password)
	}
	
	
	
}
