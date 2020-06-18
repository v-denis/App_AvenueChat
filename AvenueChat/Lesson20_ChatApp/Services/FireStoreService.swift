//
//  FireStoreService.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 19.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Firebase
import FirebaseFirestore

//MARK: - Firebase storage for caching users, profile, profile photos, chats and messages in firebase storage
class FireStoreService {
	
	static let shared = FireStoreService()
	let db = Firestore.firestore()
	var currentUser: MWUser!
	
	private var usersReferences: CollectionReference {
		return db.collection("users")
	}
	
	private var waitingChatsReference: CollectionReference {
		return db.collection(["users", currentUser.uid, "waitingChats"].joined(separator: "/"))
	}
	
	private var activeChatsReference: CollectionReference {
		return db.collection(["users", currentUser.uid, "activeChats"].joined(separator: "/"))
	}
	
	func saveProfile(id: String, email: String, userName: String, avatarImage: UIImage, description: String, gender: String, completion: @escaping (Result<MWUser,Error>) -> Void) {
		
		guard Helper.isFilled(fields: [id, email, userName, description, gender]) else {
			completion(.failure(UserErrors.notFilled))
			return
		}
		
//		guard avatarImage != #imageLiteral(resourceName: "nophoto") else { completion(.failure(UserErrors.photoNotExist))
//			return
//		}
		
		var mwuser = MWUser(email: email, username: userName, uid: id, avatarStringUrl: "NIL", description: description, gender: gender)
		
		StorageService.shared.uploadAvatar(photo: avatarImage) { (result) in
			switch result {
				
				case .success(let url):
					mwuser.avatarStringUrl = url.absoluteString
					self.usersReferences.document(mwuser.uid).setData([
						"username":mwuser.username,
						"avatarStringUrl":mwuser.avatarStringUrl,
						"description":mwuser.description,
						"email":mwuser.email,
						"gender":mwuser.gender,
						"uid":mwuser.uid]) { (error) in
							if let error = error {
								completion(.failure(error))
							} else {
								completion(.success(mwuser))
							}
				}
				case .failure(let error):
					completion(.failure(error))
			}
		}
		
		
	}
	
	func getUserData(askingUser: User, completion: @escaping (Result<MWUser,Error>) -> Void) {
		let docReference = usersReferences.document(askingUser.uid)
		
		docReference.getDocument { (document, error) in
			if let document = document, document.exists {
				guard let MWUser = MWUser(doc: document) else {
					completion(.failure(UserErrors.cantUnwrap))
					return
				}
				self.currentUser = MWUser
				completion(.success(MWUser))
			} else {
				completion(.failure(UserErrors.cantGetInfo))
			}
		}
	}
	
	
	func getUserData(askingUserUid: String, completion: @escaping (Result<MWUser,Error>) -> Void) {
		let docReference = usersReferences.document(askingUserUid)
		
		docReference.getDocument { (document, error) in
			if let document = document, document.exists {
				guard let MWUser = MWUser(doc: document) else {
					completion(.failure(UserErrors.cantUnwrap))
					return
				}
				self.currentUser = MWUser
				completion(.success(MWUser))
			} else {
				completion(.failure(UserErrors.cantGetInfo))
			}
		}
	}
	
	
	func createWaitingChat(message: String, adresat: MWUser, completion: @escaping(Result<Void,Error>) -> Void) {
		let ref = db.collection(["users", adresat.uid, "waitingChats"].joined(separator: "/"))
		let messageRef = ref.document(self.currentUser.uid).collection("messages")
		let message = MWMessage(user: currentUser, content: message)
		
		let chat = Chat(friendUsername: currentUser.username,
						friendUserImageString: currentUser.avatarStringUrl,
						lastMessageContent: message.content,
						friendId: currentUser.uid)
		
		ref.document(currentUser.uid).setData(chat.repres) {(error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			messageRef.addDocument(data: message.repres) { (error) in
				if let error = error {
					completion(.failure(error))
					return
				} else {
					completion(.success(Void()))
				}
			}
			
		}
	}
	
	
	func deleteWaitingChat(chat: Chat, completion: @escaping(Result<Void,Error>) -> Void) {
		waitingChatsReference.document(chat.friendId).delete { (error) in
			if let error = error {
				completion(.failure(error))
				return
			} else {
				completion(.success(Void()))
				
			}
		}

	}
	
	private func deleteMessages(chat: Chat, completion: @escaping(Result<Void,Error>) -> Void) {
		let ref = waitingChatsReference.document(chat.friendId).collection("messages")
		getWaitingMessages(chat: chat) { (result) in
			switch result {
				
				case .success(let messages):
					for message in messages {
						guard let documentId = message.id else { return }
						let messageRef = ref.document(documentId)
						messageRef.delete { (error) in
							if let error = error {
								completion(.failure(error))
								return
							} else {
								completion(.success(Void()))
							}
						}
				}
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}
	
	private func getWaitingMessages(chat: Chat, completion: @escaping(Result<[MWMessage],Error>) -> Void) {
		let ref = waitingChatsReference.document(chat.friendId).collection("messages")
		var messagesArray = [MWMessage]()
		ref.getDocuments { (snapshot, error) in
			if let error = error {
				completion(.failure(error))
				return
			} else {
				for doc in snapshot!.documents {
					guard let message = MWMessage(document: doc) else { return }
					messagesArray.append(message)
				}
			}
			completion(.success(messagesArray))
		}
	}
	
	func createActiveChat(chat: Chat, messages: [MWMessage], completion: @escaping(Result<Void,Error>) -> Void) {
		let messagesRefence = activeChatsReference.document(chat.friendId).collection("messages")
		activeChatsReference.document(chat.friendId).setData(chat.repres) { (error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			for message in messages {
				messagesRefence.addDocument(data: message.repres) {(error) in
					if let error = error {
						completion(.failure(error))
						return
					}
					completion(.success(Void()))
				}
			}
		}
	}
	
	func changeTopActive(chat: Chat, completion: @escaping(Result<Void,Error>) -> Void) {
		getWaitingMessages(chat: chat) { (result) in
			switch result {
				case .success(let messages):
					self.deleteMessages(chat: chat) { (result) in
						switch result {
							case .success:
								self.createActiveChat(chat: chat, messages: messages) { (result) in
									switch result {
										case .success:
											print("create active chat")
											completion(.success(Void()))
										case .failure(let error):
											completion(.failure(error))
									}
							}
							case .failure(let error):
								completion(.failure(error))
						}
				}
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}
	
	func send(chat: Chat, message: MWMessage, completion: @escaping(Result<Void,Error>) -> Void) {
		let friendReference = usersReferences.document(chat.friendId).collection("activeChats").document(currentUser.uid)
		let friendMessageReference = friendReference.collection("messages")
		let myNewMessageReference = usersReferences.document(currentUser.uid).collection("activeChats").document(chat.friendId).collection("messages")
		let friendChat = Chat(friendUsername: currentUser.username,
							  friendUserImageString: currentUser.avatarStringUrl,
							  lastMessageContent: message.content,
							  friendId: currentUser.uid)
		friendReference.setData(friendChat.repres) { (error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			friendMessageReference.addDocument(data: message.repres) { (error) in
				if let error = error {
					completion(.failure(error))
					return
				}
				myNewMessageReference.addDocument(data: message.repres) { (error) in
					if let error = error {
						completion(.failure(error))
						return
					}
					completion(.success(Void()))
				}
			}
			
		}
		
	}
	
}


