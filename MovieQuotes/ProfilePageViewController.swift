//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/21/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    var userListenerRegistration: ListenerRegistration?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListenerRegistration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid) {
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
    }
    
    func updateView() {
        displayNameTextField.text = UserDocumentManager.shared.name
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
}
