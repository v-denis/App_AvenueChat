//
//  WaitingChatCell.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

//MARK: - view of Waiting chat cells for ListViewController
class WaitingChatCell: UICollectionViewCell, ConfiguratingCellType {

	static let reuseId = "WaitingChatCell"
	
	let friendAvatarImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .orange
		layer.cornerRadius = bounds.height / 2
		clipsToBounds = true
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configurate<U>(with value: U) where U : Hashable {
		guard let chat = value as? Chat else { return }
		friendAvatarImageView.sd_setImage(with: URL(string: chat.friendImageString), completed: nil)
		
	}
}



extension WaitingChatCell {
	
	private func setupConstraints() {
		Helper.tamicOff(for: [friendAvatarImageView])
		Helper.addSubViews(superView: self, subViews: [friendAvatarImageView])
		
		NSLayoutConstraint.activate([
			friendAvatarImageView.topAnchor.constraint(equalTo: topAnchor),
			friendAvatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			friendAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			friendAvatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
}





//MARK: - UI in canvas mode
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
	
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	
	struct ContainerView: UIViewControllerRepresentable {
		
		
		let VC = TabBarViewController()
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) -> TabBarViewController {
			return VC
		}
		
		func updateUIViewController(_ uiViewController: WaitingChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) {
		}
		
	}
	
	
}



