//
//  ButtonTextField.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 13.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

class TextFieldWithButton: UIView {
	
	let button = SendMessageButton(type: .system)
	let textField = UITextField()
	
	init(backgroundColor: UIColor, font: UIFont?, textColor: UIColor, buttonColor: UIColor, borderWidth: CGFloat, borderColor: CGColor) {
		super.init(frame: .zero)
		
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor
		layer.cornerRadius = 7
		self.backgroundColor = backgroundColor
		
		textField.borderStyle = .none
		textField.textColor = textColor
		textField.backgroundColor = backgroundColor
		
		button.backgroundColor = buttonColor
		button.layer.cornerRadius = 7
		button.translatesAutoresizingMaskIntoConstraints = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(textField)
		self.addSubview(button)
		
		NSLayoutConstraint.activate([
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
			button.topAnchor.constraint(equalTo: topAnchor, constant: 7),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
			button.widthAnchor.constraint(equalTo: button.heightAnchor)
		])
		
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
			textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -7),
			textField.topAnchor.constraint(equalTo: topAnchor),
			textField.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
