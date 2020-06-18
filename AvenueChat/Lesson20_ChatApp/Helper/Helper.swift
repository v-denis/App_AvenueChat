//
//  Helper.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

class Helper {
	
	static func tamicOff(for views: [UIView]) {
		for view in views {
			view.translatesAutoresizingMaskIntoConstraints = false
		}
	}
	
	static func addSubViews(superView: UIView, subViews: [UIView]) {
		for view in subViews {
			superView.addSubview(view)
		}
	}
	
	static func isFilled(fields: [String?]) -> Bool {
		for field in fields {
			guard let field = field, field != "" else { return false }
		}
		return true
	}
}
