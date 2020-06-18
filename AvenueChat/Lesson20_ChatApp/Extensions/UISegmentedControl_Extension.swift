//
//  UISegmentedControl_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import Foundation


extension UISegmentedControl {
	
	convenience init(left: String, right: String) {
		self.init()
		insertSegment(withTitle: left, at: 0, animated: true)
		insertSegment(withTitle: right, at: 1, animated: true)
		
		selectedSegmentIndex = 0
	}
	
}
