//
//  UIStackView_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit


extension UIStackView {
	
	
	convenience init(arrangedViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
		self.init(arrangedSubviews: arrangedViews)
		self.axis = axis
		self.spacing = spacing
	}
	
}
