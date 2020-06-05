//
//  SignInVC.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/5/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 8
    }
    
    //if a user is already logged in, this function will grab the username and skip the login page, going straight to mainVC
    override func viewDidAppear(_ animated: Bool) {
        setUsername()
        if AuthService.instance.isLoggedIn {
            performSegue(withIdentifier: "showMainVC", sender: nil)
        }
    }
    
    //takes a title and message and uses them to create and show a custom alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUsername() {
        if let user = Firebase.Auth.auth().currentUser {
            AuthService.instance.isLoggedIn = true
            let emailComponents = user.email?.components(separatedBy: "@")
            if let username = emailComponents?[0] {
                AuthService.instance.username = username
            }
            else {
                AuthService.instance.isLoggedIn = false
                AuthService.instance.username = nil
            }
        }
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Error", message: "Please enter an email and a password")
            return
        }
        
        guard email != "", password != "" else {
            showAlert(title: "Error", message: "Please enter an email and password")
            return
        }
        
        AuthService.instance.emailLogin(email, password: password) { (success, message) in
            if success {
                self.setUsername()
                self.performSegue(withIdentifier: "showMainVC", sender: nil)
            }
            else {
                self.showAlert(title: "Failure", message: message)
            }
        }
        
    }
}
