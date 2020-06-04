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
    weak var delegat: DataServiceDelegate?
}

