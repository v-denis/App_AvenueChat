//
//  ActiveChatCell.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import SwiftUI

//MARK: - view of Active chat cells for ListViewController
class ActiveChatCell: UICollectionViewCell, ConfiguratingCellType {
    
	static let reuseId = "ActiveChatCell"
	
	let friendImageView = UIImageView()
	let friendNameLabel = UILabel(text: "User name", font: UIFont.appleSDGothicNeo20)
	let lastMessageLabel = UILabel(text: "Last message", font: UIFont.appleSDGothicNeo18)
	let gradientView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		gradientView.backgroundColor = .systemBlue
		setupConstaints()
	}
	
	func configurate<U>(with value: U) where U: Hashable {
		guard let chat: Chat = value as? Chat else { return }
//		friendImageView.sd_setImage(with: URL(string: chat.friendImageString), completed: nil)
		friendNameLabel.text = chat.friendUsername
		lastMessageLabel.text = chat.lastMessageContent
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


//Constraints
extension ActiveChatCell {
	
	private func setupConstaints() {
		
		Helper.tamicOff(for: [friendImageView, friendNameLabel, lastMessageLabel, gradientView])
		Helper.addSubViews(superView: self, subViews: [friendImageView, friendNameLabel, lastMessageLabel, gradientView])
		
		NSLayoutConstraint.activate([
			friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			friendImageView.heightAnchor.constraint(equalToConstant: 80),
			friendImageView.widthAnchor.constraint(equalToConstant: 80)
		])
		
		NSLayoutConstraint.activate([
			gradientView.topAnchor.constraint(equalTo: friendImageView.topAnchor),
			gradientView.bottomAnchor.constraint(equalTo: friendImageView.bottomAnchor),
			gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
			gradientView.widthAnchor.constraint(equalToConstant: 5)
		])
		
		NSLayoutConstraint.activate([
			friendNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 5),
			friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -5)
		])
		
		NSLayoutConstraint.activate([
			lastMessageLabel.topAnchor.constraint(equalTo: friendNameLabel.bottomAnchor, constant: 5),
			lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 5),
			lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -5)
		])
		
	}
	
}


