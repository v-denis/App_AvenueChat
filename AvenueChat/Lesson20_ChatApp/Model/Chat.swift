//
//  Chat.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Chat: Hashable, Decodable {
	
	var friendUsername: String
	var friendImageString: String
	var lastMessageContent: String
	var friendId: String
	
	var repres: [String:Any] {
		var repres: [String:Any] = ["friendUsername":friendUsername]
//		repres["friendUsername"] = friendUsername
		repres["friendImageString"] = friendImageString
		repres["lastMessageContent"] = lastMessageContent
		repres["friendId"] = friendId
		return repres
	}
	
	init(friendUsername: String, friendUserImageString: String, lastMessageContent: String, friendId: String) {
		self.friendId = friendId
		self.friendUsername = friendUsername
		self.friendImageString = friendUserImageString
		self.lastMessageContent = lastMessageContent
	}
	
	init?(doc: QueryDocumentSnapshot) {
		let data = doc.data()
		
		guard let friendUsername = data["friendUsername"] as? String else { return nil }
		guard let friendImageString = data["friendImageString"] as? String else { return nil }
		guard let lastMessageContent = data["lastMessageContent"] as? String else { return nil }
		guard let friendId = data["friendId"] as? String else { return nil }
		
		self.friendUsername = friendUsername
		self.friendImageString = friendImageString
		self.lastMessageContent = lastMessageContent
		self.friendId = friendId
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(friendId)
	}
	
	static func == (lhs: Chat, rhs: Chat) -> Bool {
		return lhs.friendId == rhs.friendId
	}
	
	func contains(filter: String?) -> Bool {
		guard let filtered = filter else { return true }
		if filtered.isEmpty { return true }
		let lowerFilter = filtered.lowercased()
		return friendUsername.lowercased().contains(lowerFilter)
	}
}
