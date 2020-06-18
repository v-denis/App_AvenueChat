//
//  SectionHeader.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
 
	static let reuseId = "SectionHeader"
	let titleLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		Helper.tamicOff(for: [titleLabel])
		Helper.addSubViews(superView: self, subViews: [titleLabel])
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	func configurate(text: String, font: UIFont?, textColor: UIColor) {
		titleLabel.text = text
		titleLabel.textColor = textColor
		titleLabel.font = font
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
