//
//  StorageManager.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/26/22.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class StorageManager {
    static let shared = StorageManager()
    var _storageRef: StorageReference
    
    private init() {
        _storageRef = Storage.storage().reference()
    }
    
    func uploadProfilePhoto(uid: String, image: UIImage) {
        guard let imageData = ImageUtils.resize(image: image) else {
            print("Converting the image to data failed!")
            return
        }
        let photoRef = _storageRef.child(kUsersCollectionPath).child(uid)
        photoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("There was an error uploading the image \(error)")
                return
            }
            print("Upload complete.  Getting the download url.")
            photoRef.downloadURL { downloadUrl, error in
                if let error = error {
                    print("There was an error getting the download URL of the image \(error)")
                    return
                }
                print("Got the download URL \(downloadUrl?.absoluteString)")
                UserDocumentManager.shared.updatePhotoUrl(photoUrl: downloadUrl?.absoluteString ?? "")
            }
        }
    }
}
