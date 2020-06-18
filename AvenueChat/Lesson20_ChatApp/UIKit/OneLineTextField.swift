//
//  OneLineTextField.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import Foundation

class OneLineTextField: UITextField {
	
	convenience init(font: UIFont? = .appleSDGothicNeo20) {
		self.init()
		self.font = font
		borderStyle = .none
		translatesAutoresizingMaskIntoConstraints = false
		autocapitalizationType = .none
		autocorrectionType = .no
		
		let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		bottomView.backgroundColor = UIColor.customGray
		bottomView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(bottomView)
		
		NSLayoutConstraint.activate([bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
									 bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
									 bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
									 bottomView.heightAnchor.constraint(equalToConstant: 1)
		])
	}
}
