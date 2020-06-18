//
//  ListenerService.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 26.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

//MARK: - service of observers which are listening for changes in user documents, messeges and chats
class ListenerService {
	
	static let shared = ListenerService()
	private let db = Firestore.firestore()
	
	private var usersReference: CollectionReference {
		return db.collection("users")
	}
	
	private var currentUserUid: String {
		return Auth.auth().currentUser!.uid
	}
	
	func usersObserve(users: [MWUser], completion: @escaping (Result<[MWUser], Error>) -> Void) -> ListenerRegistration? {
		var tempUsers = users
		let usersListener = usersReference.addSnapshotListener { (snapshot, error) in
			guard let snapshot = snapshot else {
				completion(.failure(error!))
				return
			}
			
			snapshot.documentChanges.forEach { (documentChange) in
				guard let user = MWUser(doc: documentChange.document) else { return }
				
				switch documentChange.type {
					
					case .added:
						guard !tempUsers.contains(user) else { return }
						guard user.uid != self.currentUserUid else { return }
						tempUsers.append(user)
					
					case .modified:
						guard let index = users.firstIndex(of: user) else { return }
						tempUsers[index] = user
					
					case .removed:
						guard let index = users.firstIndex(of: user) else { return }
						tempUsers.remove(at: index)
				}
			}
			completion(.success(tempUsers))
		}
		return usersListener
	}
	
	
	func waitingChatsObserve(chats: [Chat], completion: @escaping (Result<[Chat], Error>) -> Void) -> ListenerRegistration? {
		
		var waitingChats = chats
		let chatsRef = db.collection(["users", currentUserUid, "waitingChats"].joined(separator: "/"))
		let chatsListener = chatsRef.addSnapshotListener { (snapshot, error) in
			guard let snapshot = snapshot else {
				completion(.failure(error!))
				return
			}
			
			snapshot.documentChanges.forEach { (change) in
				guard let chat = Chat(doc: change.document) else { return }
				
				switch change.type {
					
					case .added:
						guard !waitingChats.contains(chat) else { return }
						waitingChats.append(chat)
					case .modified:
						guard let index = waitingChats.firstIndex(of: chat) else { return }
						waitingChats[index] = chat
					case .removed:
						guard let index = waitingChats.firstIndex(of: chat) else { return }
						waitingChats.remove(at: index)
				}
			}
			completion(.success(waitingChats))
		}
		return chatsListener
	}
	
	func activeChatsObserve(chats: [Chat], completion: @escaping (Result<[Chat], Error>) -> Void) -> ListenerRegistration? {
		
		var activeChats = chats
		let chatsRef = db.collection(["users", currentUserUid, "activeChats"].joined(separator: "/"))
		let chatsListener = chatsRef.addSnapshotListener { (snapshot, error) in
			guard let snapshot = snapshot else {
				completion(.failure(error!))
				return
			}
			
			snapshot.documentChanges.forEach { (change) in
				guard let chat = Chat(doc: change.document) else { return }
				
				switch change.type {
					
					case .added:
						guard !activeChats.contains(chat) else { return }
						activeChats.append(chat)
					case .modified:
						guard let index = activeChats.firstIndex(of: chat) else { return }
						activeChats[index] = chat
					case .removed:
						guard let index = activeChats.firstIndex(of: chat) else { return }
						activeChats.remove(at: index)
				}
			}
			completion(.success(activeChats))
		}
		return chatsListener
	}
	func messageObserve(chat: Chat, completion: @escaping (Result<MWMessage, Error>) -> Void) -> ListenerRegistration {
		let ref = usersReference.document(currentUserUid).collection("activeChats").document(chat.friendId).collection("messages")
		let listener = ref.addSnapshotListener { (snapshot, error) in
			guard let snap = snapshot else {
				completion(.failure(error!))
				return
			}
			snap.documentChanges.forEach { (change) in
				guard let message = MWMessage(document: change.document) else {
					return
				}
				switch change.type {
					
					case .added:
						completion(.success(message))
					case .modified:
					break
					case .removed:
					break
				}
			}
			
		}
		return listener
	}
}
