//
//  LoginViewController.swift
//  firebase_registration
//
//  Created by Yusata Infotech Pvt Ltd on 14/08/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func loginButtonTapped(_ sender: UIButton) {
    guard let email = emailTextField.text, !email.isEmpty,
          let password = passwordTextField.text, !password.isEmpty else {
      // Show error
        showAlert(title: "Validation Error", message: "Email and password cannot be empty.")
      return
    }
    
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print("Error signing in: \(error.localizedDescription)")
        // Show error
          self.showAlert(title: "Login Error", message: error.localizedDescription)
        return
      }
      
      // Navigate to the next screen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
  }

  @IBAction func registerButtonTapped(_ sender: UIButton) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
      
      self.navigationController?.pushViewController(vc!, animated: true)
  }
    private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
