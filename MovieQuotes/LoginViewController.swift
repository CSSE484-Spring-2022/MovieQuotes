//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/18/22.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
        googleSignInButton.style = GIDSignInButtonStyle.wide
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
    
    @IBAction func pressedRosefire(_ sender: Any) {
        print("Using Rosefire")
        
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: kRosefireRegistryToken) { (err, result) in
            if let err = err {
                print("Rosefire sign in error! \(err)")
                return
            }
            //          print("Result = \(result!.token!)")
            //          print("Result = \(result!.username!)")
            print("Rosefire worked.  Name = \(result!.name!)")
            //          print("Result = \(result!.email!)")
            //          print("Result = \(result!.group!)")
            
            AuthManager.shared.signInWithRosefireToken(result!.token)
        }
    }
    
    
    @IBAction func pressedGoogleSignIn(_ sender: Any) {
        
        print("TODO: Sign in with Google")
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            
            if let error = error {
                print("Error with Google Sign In \(error)")
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            print("Google Sign in Worked!  Now use the credential to do the real Firebase sign in.")
            AuthManager.shared.signInWithGoogleCredential(credential)
        }
        
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
