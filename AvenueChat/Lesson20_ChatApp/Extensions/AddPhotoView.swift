//
//  AddPhotoView.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import Foundation

class AddPhotoView: UIView {
	
	var circleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = #imageLiteral(resourceName: "nophoto")
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .buttonDark
		imageView.layer.cornerRadius = imageView.frame.size.height / 2
		
		return imageView
	}()
	
	let plusButton: UIButton = {
		
		let button = UIButton(type: .system)
		let buttonImage = UIImage(systemName: "plus")
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(buttonImage, for: .normal)
		button.tintColor = UIColor.buttonDark
		
		return button
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(circleImageView)
		addSubview(plusButton)
		
		setupConstraints()
	}
	
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			circleImageView.topAnchor.constraint(equalTo: topAnchor),
			circleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			circleImageView.heightAnchor.constraint(equalToConstant: 130),
			circleImageView.widthAnchor.constraint(equalToConstant: 130)
		])
		
		NSLayoutConstraint.activate([
			plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 10),
			plusButton.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor),
			plusButton.heightAnchor.constraint(equalToConstant: 40),
			plusButton.widthAnchor.constraint(equalToConstant: 40)
		])
		
		self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
		self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		circleImageView.layer.cornerRadius = circleImageView.layer.bounds.height / 2
		circleImageView.layer.masksToBounds = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
