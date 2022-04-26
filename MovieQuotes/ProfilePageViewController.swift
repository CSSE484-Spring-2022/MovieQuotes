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
    
    @IBAction func displayNameDidChange(_ sender: Any) {
//        print("TODO: Update name to \(displayNameTextField.text)")
        UserDocumentManager.shared.updateName(name: displayNameTextField.text!)
    }
    
    
    @IBAction func pressedChangeProfilePhoto(_ sender: Any) {
        print("TODO: Change photo")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true)
    }
    
    
    func updateView() {
        displayNameTextField.text = UserDocumentManager.shared.name
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
}



extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            
//            profilePhotoImageView.image = image  // Quick test to see if Step #1 is done!
            StorageManager.shared.uploadProfilePhoto(uid: AuthManager.shared.currentUser!.uid,
                                                     image: image)
            
        }
        picker.dismiss(animated: true)
    }
}
