//
//  AuthError.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 14.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

enum AuthError {
	case nonFilled
	case passwordNotMatched
	case unknownError
	case serverError
	
	
}

extension AuthError: LocalizedError {
	
	var errorDescription: String? {
		switch self {
			
			case .nonFilled:
				return NSLocalizedString("Заполните все поля", comment: "")
			case .passwordNotMatched:
				return NSLocalizedString("Пароли не совпадают", comment: "")
			case .unknownError:
				return NSLocalizedString("Неизвестная ошибка", comment: "")
			case .serverError:
				return NSLocalizedString("Ошибка сервера", comment: "")
		}
	}
}
