//
//  UserErrors.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 19.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

enum UserErrors {
	case notFilled
	case photoNotExist
	case cantGetInfo
	case cantUnwrap
}

extension UserErrors: LocalizedError {
	
	var errorDescription: String? {
		switch self {
			case .notFilled: return NSLocalizedString("Заполните все поля", comment: "")
			case .photoNotExist: return NSLocalizedString("Фото не найдено", comment: "")
			case .cantGetInfo: return NSLocalizedString("Не удалось загрузить информацию из БД", comment: "")
			case .cantUnwrap: return NSLocalizedString("Не удалось извлечь пользователя", comment: "")
		}
	}
}
