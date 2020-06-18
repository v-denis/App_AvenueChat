//
//  WaitNavigationProtocol.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 28.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit

protocol WaitNavigationProtocol {
	func removeChat(chat: Chat)
	func activateChat(chat: Chat)
}
