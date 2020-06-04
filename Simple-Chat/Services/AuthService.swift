//
//  AuthService.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/3/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    var username: String?
    var isLoggedIn = false
    
    func emailLogin(_ email: String, password: String, completion: @escaping (_ Success: Bool, _ message: String) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user, error) in
            if error != nil {
                if let errorCode = Firebase.AuthErrorCode(rawValue: (error?._code)!) {
                    if errorCode == .userNotFound {
                        Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                completion(false, "Error creating account")
                            }
                            else {
                                completion(true, "Successfully created account")
                            }
                        })
                    }
                    else {
                        completion(false, "Sorry, incorrect email or password")
                    }
                }
            }
            else {
                completion(true, "Successfully Logged In")
            }
        })
    }
}
