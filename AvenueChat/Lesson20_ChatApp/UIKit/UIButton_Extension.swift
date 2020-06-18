//
//  UIButton_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

extension UIButton {
	
	convenience init(title: String,
					 backgroundColor: UIColor,
					 titleColor: UIColor,
					 font: UIFont?,
					 cornerRadius: CGFloat = 6,
					 isShadow: Bool = false) {
		
		self.init(type: .system)
		self.setTitle(title, for: .normal)
		self.setTitleColor(titleColor, for: .normal)
		self.backgroundColor = backgroundColor
		self.titleLabel?.font = font
		self.layer.cornerRadius = cornerRadius
		
		if isShadow {
			layer.shadowColor = UIColor.black.cgColor
			layer.shadowRadius = 5
			layer.shadowOpacity = 0.2
			layer.shadowOffset = CGSize(width: 0, height: 3)
			
		}
		
	
	}
	
}
