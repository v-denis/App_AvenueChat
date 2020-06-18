//
//  UIApplication_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 26.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
	
	
	class func getTopVC(baseVC: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		
		if let navVC = baseVC as? UINavigationController {
			return getTopVC(baseVC: navVC.visibleViewController)
		} else if let tabBarVC = baseVC as? UITabBarController, let selected = tabBarVC.selectedViewController {
			return getTopVC(baseVC: selected)
		} else if let presented = baseVC?.presentedViewController {
			return getTopVC(baseVC: presented)
		}
		return baseVC
	}
}
