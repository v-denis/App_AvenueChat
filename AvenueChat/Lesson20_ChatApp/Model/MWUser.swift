//
//  User.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 12.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct MWUser: Hashable, Decodable {
	
	var email: String
	var username: String
	var uid: String
	var avatarStringUrl: String
	var description: String
	var gender: String
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(uid)
	}
	
	static func == (lhs: MWUser, rhs: MWUser) -> Bool {
		return lhs.uid == rhs.uid
	}
	
	
	init?(doc: DocumentSnapshot) {
		guard let data = doc.data() else { return nil }
		
		guard let id = data["uid"] as? String else { return nil }
		guard let email = data["email"] as? String else { return nil }
		guard let username = data["username"] as? String else { return nil }
		guard let avatarStringUrl = data["avatarStringUrl"] as? String else { return nil }
		guard let description = data["description"] as? String else { return nil }
		guard let gender = data["gender"] as? String else { return nil }
		
		self.username = username
		self.email = email
		self.uid = id
		self.avatarStringUrl = avatarStringUrl
		self.description = description
		self.gender = gender
	}
	
	init?(doc: QueryDocumentSnapshot) {
		let data = doc.data()
		
		guard let id = data["uid"] as? String else { return nil }
		guard let email = data["email"] as? String else { return nil }
		guard let username = data["username"] as? String else { return nil }
		guard let avatarStringUrl = data["avatarStringUrl"] as? String else { return nil }
		guard let description = data["description"] as? String else { return nil }
		guard let gender = data["gender"] as? String else { return nil }
		
		self.username = username
		self.email = email
		self.uid = id
		self.avatarStringUrl = avatarStringUrl
		self.description = description
		self.gender = gender
	}
	
	init(email: String, username: String, uid: String, avatarStringUrl: String, description: String, gender: String) {
		self.email = email
		self.username = username
		self.uid = uid
		self.avatarStringUrl = avatarStringUrl
		self.description = description
		self.gender = gender
	}
	
	func contains(filter: String?) -> Bool {
		guard let filtered = filter else { return true }
		if filtered.isEmpty { return true }
		let lowerFilter = filtered.lowercased()
		return username.lowercased().contains(lowerFilter)
	}
}
