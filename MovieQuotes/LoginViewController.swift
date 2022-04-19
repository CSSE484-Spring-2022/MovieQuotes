//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/18/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginObserver {
            print("Login complete.  Go to the List page")
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }
    
    @IBAction func pressedCreateNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        print("Pressed New User.  Email: \(email)  Password: \(password)")
        
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
    }
    
    @IBAction func pressedLogInExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        print("Pressed log in existing user.  Email: \(email)  Password: \(password)")
        
        AuthManager.shared.loginExistingEmailPasswordUser(email: email, password: password)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
