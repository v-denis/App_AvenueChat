//
//  ConfiguratingCellType.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 07.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

protocol ConfiguratingCellType {
	
	static var reuseId: String { get }
	func configurate<U: Hashable>(with value: U)
	
}
