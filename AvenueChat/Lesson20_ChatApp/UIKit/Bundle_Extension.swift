//
//  Bundle_Extension.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 05.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

extension Bundle {
	
	func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
		guard let url = self.url(forResource: file, withExtension: nil) else { fatalError("No such file or directory!") }
		guard let data = try? Data(contentsOf: url) else { fatalError("Ошибка извлечения даты!") }
		let decoder = JSONDecoder()
		
		guard let loaded = try? decoder.decode(T.self, from: data) else { fatalError("Ошибка декодирования!") }
		
		return loaded
		
	}
}
