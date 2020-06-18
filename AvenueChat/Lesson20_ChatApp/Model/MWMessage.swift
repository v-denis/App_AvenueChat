//
//  MWMessage.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 26.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import MessageKit

struct MWMessage: MessageType {
	
	var sender: SenderType
	let content: String
	var sentDate: Date
	var id: String?
	
	var messageId: String {
		return id ?? UUID().uuidString
	}
	var kind: MessageKind {
		return .text(content)
	}
	
	var repres: [String: Any] {
		var repres: [String:Any] = ["content":content]
		repres["id"] = id
		repres["date"] = sentDate
		repres["senderId"] = sender.senderId
		repres["senderName"] = sender.displayName
		return repres
	}
	
	
	init(user: MWUser, content: String) {
		self.content = content
		self.sender = Sender(senderId: user.uid, displayName: user.username)
		self.sentDate = Date()
		self.id = nil //FIXME: incorrect id
	}

	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		
		guard let senderName = data["senderName"] as? String else {
			print("writerNameError")
			return nil }
		guard let senderID = data["senderId"] as? String else {
			print("writerIDError")
			return nil }
		guard let date = document.get("date") as? Timestamp else {
			print("dateError")
			return nil }
//		guard let date = document.get("date") as? Date else { return nil }
		guard let content = data["content"] as? String else {
			print("contentError")
			return nil }
		
		self.sentDate = date.dateValue()
		self.id = document.documentID
		self.content = content
		self.sender = Sender(senderId: senderID, displayName: senderName)
	}
}



extension MWMessage: Comparable {
	
	static func < (lhs: MWMessage, rhs: MWMessage) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}
	
	static func == (lhs: MWMessage, rhs: MWMessage) -> Bool {
		return lhs.messageId == rhs.messageId
	}
	
}
