//
//  AuthenticationService.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 14.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import Firebase

//MARK: - service for authorization by email and password. Firebase save connection after sign up
class AuthService {
	
	static var shared = AuthService()
	private let auth = Auth.auth()
	
	
	func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User,Error>) -> Void) {
		
		auth.createUser(withEmail: email!, password: password!) { (result, error) in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			guard Helper.isFilled(fields: [email, password, confirmPassword]) else {
				completion(.failure(AuthError.nonFilled))
				return
			}
			completion(.success(result.user))
		}
		
	}
	
	
	
	func login(email: String?, password: String?, completion: @escaping(Result<User,Error>) -> Void) {
		
		guard let email = email, let password = password else {
			completion(.failure(AuthError.nonFilled))
			return
		}
		
		auth.signIn(withEmail: email, password: password) { (result, error) in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			completion(.success(result.user))
		}
		
	}
	
	
}
