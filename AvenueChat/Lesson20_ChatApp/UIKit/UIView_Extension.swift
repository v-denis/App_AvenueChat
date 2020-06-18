//
//  UIView_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 14.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	convenience init(backgroundColor: UIColor, cornerRadius: CGFloat) {
		self.init()
		self.backgroundColor = backgroundColor
		layer.cornerRadius = cornerRadius
	}
}
