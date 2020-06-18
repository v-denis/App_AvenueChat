//
//  UILabel_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
	
	
extension UILabel {
	
	convenience init(text: String, font: UIFont? = UIFont.appleSDGothicNeo20) {
		self.init()
		self.text = text
		self.font = font
		
	}
	
	convenience init(text: String, font: UIFont? = UIFont.appleSDGothicNeo20, numberOfLines: Int) {
		self.init()
		self.text = text
		self.font = font
		self.numberOfLines = numberOfLines
		lineBreakMode = .byWordWrapping
	}
	
}
