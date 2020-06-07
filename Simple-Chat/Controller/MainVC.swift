//
//  MainVC.swift
//  Simple-Chat
//
//  Created by Ben Arteaga on 6/5/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    //moves the entire view up by the size of the keyboard
    @objc func keyboardWillShow(notif: NSNotification) {
        if let keyboardSize = (notif.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //shifts the entire view down by the size of the keyboard
    @objc func keyboardWillHide(notif: NSNotification) {
        if let keyboardSize = (notif.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        do {
            try Firebase.Auth.auth().signOut()
            performSegue(withIdentifier: "showSignInVC", sender: nil)
        } catch {
            print("An error occured signing out")
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text else {
            showAlert(title: "Error", message: "Please enter a message")
            return
        }
        guard messageText != "" else {
            showAlert(title: "Error", message: "No message to send")
            return
        }
        if let user = AuthService.instance.username {
            DataService.instance.saveMessage(user, message: messageText)
            messageTextField.text = ""
            dismissKeyboard()
            tableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MainVC: DataServiceDelegate {
    func dataLoaded() {
        tableView.reloadData()
        if DataService.instance.messages.count > 0 {
            let indexPath = IndexPath(row: DataService.instance.messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = DataService.instance.messages[(indexPath as NSIndexPath).row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell {
            if let user = msg.userId, let message = msg.message {
                cell.configureCell(user: user, message: message)
            }
            return cell
        }
        else {
            return MessageCell()
        }
    }
}
