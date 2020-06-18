//
//  OneLineTextField.swift
//  AvenueChat
//
//  Created by Влад Мади on 29.02.2020.
//  Copyright © 2020 Влад Мади. All rights reserved.
//

import UIKit

class OneLineTextField: UITextField {
    convenience init(font: UIFont? = .appleSDGothicNeo26) {
        self.init()
        self.font = font
        self.borderStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        var bottomView = UIView()
        bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .customGray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
        
        NSLayoutConstraint.activate([bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     bottomView.heightAnchor.constraint(equalToConstant: 1)])
    }
}
