//
//  ButtonFormView.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 22.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class ButtonFormView: UIView {

	init(label: UILabel, button: UIButton) {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(label)
		addSubview(button)
		
		//Constraints for label
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: topAnchor),
			label.leadingAnchor.constraint(equalTo: leadingAnchor)
		])
		
		//Constraints for button
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
			button.leadingAnchor.constraint(equalTo: leadingAnchor),
			button.trailingAnchor.constraint(equalTo: trailingAnchor),
			button.heightAnchor.constraint(equalToConstant: 55)
		])
		
		bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
