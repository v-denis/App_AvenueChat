//
//  StorageService.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 21.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class StorageService {
	
	static let shared = StorageService()
	let storageReference = Storage.storage().reference()
	
	private var avatarsReference: StorageReference {
		return storageReference.child("avatars")
	}
	
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
	
	func uploadAvatar(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void ) {
		
		guard let scaledPhoto = photo.scaledToSafeUploadSize, let imageData = scaledPhoto.jpegData(compressionQuality: 0.5) else { return }
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		avatarsReference.child(currentUserId).putData(imageData, metadata: metaData) { (storageMetaData, error) in
			
			guard let _ = storageMetaData else { completion(.failure(error!)); return }
			
			self.avatarsReference.child(self.currentUserId).downloadURL { (url, error) in
				guard let downloadUrl = url else { completion(.failure(error!)); return }
				
				completion(.success(downloadUrl))
			}
		}
		
	}
	
}
