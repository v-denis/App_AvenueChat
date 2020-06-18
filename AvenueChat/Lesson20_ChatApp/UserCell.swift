//
//  UserCell.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 12.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import SDWebImage

//MARK: - view of User cells for PeopleViewController
class UserCell: UICollectionViewCell, ConfiguratingCellType {
    
	static let reuseId = String(describing: UserCell.self)
	
	let userImageView = UIImageView()
	let userNameLabel = UILabel(text: "Вася Пупкин", font: UIFont.appleSDGothicNeo18)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		layer.cornerRadius = 5
		clipsToBounds = true
		setupConstraints()
//		userImageView.contentMode = .scaleAspectFill
	}
	
	func configurate<U>(with value: U) where U : Hashable {
		guard let user: MWUser = value as? MWUser else { return }
		
		let url = URL(string: user.avatarStringUrl)
		userImageView.sd_setImage(with: url, completed: nil)
		userNameLabel.text = user.username
//		userImageView.contentMode = .scaleAspectFit
//		userNameLabel.backgroundColor = .white
//		userNameLabel.layer.cornerRadius = 5
//		userNameLabel.clipsToBounds = true
	}
	
	override func prepareForReuse() {
		userImageView.image = nil
	}
	
	private func setupConstraints() {
		Helper.tamicOff(for: [userNameLabel, userImageView])
		Helper.addSubViews(superView: self, subViews: [userNameLabel, userImageView])
		
		NSLayoutConstraint.activate([
			userImageView.topAnchor.constraint(equalTo: topAnchor),
			userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			userImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
