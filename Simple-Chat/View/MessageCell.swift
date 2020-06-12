//
//  MessageCell.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/7/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(user: String, message: String, isSelf: Bool) {
        userLabel.text = user
        messageLabel.text = message
        if isSelf {
            messageLabel.textAlignment = .right
        }
    }

}
