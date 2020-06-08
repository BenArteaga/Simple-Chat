//
//  HeaderView.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/8/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    override func awakeFromNib() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
    }

}
