//
//  DataService.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/4/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import Foundation
import Firebase

protocol DataServiceDelegate: class {
    func dataLoaded()
}

class DataService {
    static let instance = DataService()
    let ref = Firebase.Database.database().reference()
    var messages: [Message] = []
    weak var delegate: DataServiceDelegate?
    
    //loads messages from Firebase and stores the in messages array
    func loadMessages(_ completion: @escaping (_ Success: Bool) -> Void) {
        //observes the value of that Firebase location
        ref.observe(.value) { (data: Firebase.DataSnapshot) in
            if data.value != nil {
                let unsortedMessages = Message.messageArrayFromFBData(data.value! as AnyObject)
                //sorts messages into chronological order
                self.messages = unsortedMessages.sorted(by: {$0.messageId < $1.messageId})
                self.delegate?.dataLoaded()
                if self.messages.count > 0 {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                completion(false)
            }
        }
    }
    
    //function to save a message to our Firebase backend
    func saveMessage(_ user: String, message: String) {
        //autoId has a timestamp in it so that we can later sort the messages in chronological order
        let key = ref.childByAutoId().key
        let message = ["user": user, "message": message]
        let messageUpdates = ["/\(key)": message]
        ref.updateChildValues(messageUpdates)
    }
}

