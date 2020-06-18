//
//  UIImage_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//


import Foundation
import UIKit

extension UIImageView {
	
	convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
		self.init()
		
		self.image = image
		self.contentMode = contentMode
	}
	
	convenience init(avatarImage: UIImage?, contentMode: UIView.ContentMode, frame: CGRect) {
		self.init()
		
		self.image = image
		self.contentMode = contentMode
		self.frame = frame
	}
	
}
