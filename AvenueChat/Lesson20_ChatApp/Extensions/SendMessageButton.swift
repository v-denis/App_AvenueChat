//
//  SendMessageButton.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 01.04.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

	override var isHighlighted: Bool {
		willSet {
			backgroundColor = (newValue) ? backgroundColor?.withAlphaComponent(0.4) : backgroundColor?.withAlphaComponent(1.0)
		}
	}
}
