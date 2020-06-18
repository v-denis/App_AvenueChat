//
//  VC_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 12.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	
	func configurate<T: ConfiguratingCellType, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Не удалось сконфигурировать ячейку!") 	}
		cell.configurate(with: value)
		
		return cell
	}
	
	func showAlert(title: String, message: String, handler: @escaping (UIAlertAction) -> Void = { _ in }) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
		
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
	
}
