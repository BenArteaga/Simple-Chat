//
//  Message.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/4/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import Foundation

struct Message {
    fileprivate let _messageId: String
    fileprivate let _userId: String?
    fileprivate let _message: String?
    
    var messageId: String {
        return _messageId
    }
    
    var userId: String? {
        return _userId
    }
    
    var message: String? {
        return _message
    }
    
    //initializes a message using Firebase data in the form of a dictionary
    init(messageId: String, messageData: Dictionary<String, AnyObject>) {
        _messageId = messageId
        _userId = messageData["user"] as? String
        _message = messageData["message"] as? String
    }
}
