//
//  User.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 12.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

struct FakeUser: Hashable, Decodable {
	
	var username: String
	var avatarStringURL: String
	var id: Int
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: FakeUser, rhs: FakeUser) -> Bool {
		return lhs.id == rhs.id
	}
}
