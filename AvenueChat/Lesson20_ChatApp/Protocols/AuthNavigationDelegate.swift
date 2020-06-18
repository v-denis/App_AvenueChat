//
//  AuthNavigationDelegate.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 19.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

protocol AuthNavigationDelegate: class {
	func toLoginViewController()
	func toSignUpViewController()
}
