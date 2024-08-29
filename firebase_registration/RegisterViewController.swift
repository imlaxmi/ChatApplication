//
//  RegisterViewController.swift
//  firebase_registration
//
//  Created by Yusata Infotech Pvt Ltd on 14/08/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    var ref: DatabaseReference!
    
  override func viewDidLoad() {
    super.viewDidLoad()
      ref = Database.database().reference()
  }

  @IBAction func registerButtonTapped(_ sender: UIButton) {
    guard let email = emailTextField.text, !email.isEmpty,
          let password = passwordTextField.text, !password.isEmpty,
          let username = usernameTextField.text, !username.isEmpty else {
      // Show error
      return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print("Error registering: \(error.localizedDescription)")
        // Show error
        return
      }
        guard let user = authResult?.user else { return }
                    
                    let userInfo = [
                        "username": username,
                        "email": email
                    ]
                    
        self.ref.child("users").child(user.uid).setValue(userInfo) { error, _ in
            if let error = error {
                print("Error saving user info: \(error.localizedDescription)")
            } else {
                // Successfully saved user info
                self.navigationController?.popViewController(animated: true)
            }
        }
      // Navigate to the login screen or next screen
     // self.navigationController?.popViewController(animated: true)
    }
  }
    
}
