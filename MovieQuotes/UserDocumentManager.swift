//
//  UserDocumentManager.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/25/22.
//

import Foundation
import Firebase

class UserDocumentManager {

    var _latestDocument: DocumentSnapshot?
    
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        _collectionRef = Firestore.firestore().collection(kUsersCollectionPath)
    }
    
    // TODO: Implement Create!
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        // *Get* the User Document for this uid
        // If it already exists do nothing! (2nd or great signin)
        // There is NOT User document, make it using the name and photoUrl
        
        let docRef = _collectionRef.document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exist.  Do nothing.  Here is the data: \(document.data()!)")
            } else {
                print("Document does not exist.  Create this user!")
                docRef.setData([
                    kUserName: name ?? "",
                    kUserPhotoUrl: photoUrl ?? ""
                ])
            }
        }
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = _collectionRef.document(documentId)
        
        return query.addSnapshotListener { documentSnapshot, error in
            self._latestDocument = nil
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard document.data() != nil else {
              print("Document data was empty.")
              return
            }
            self._latestDocument = document
            changeListener()
          }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    var name: String {
        if let name = _latestDocument?.get(kUserName) {
            return name as! String
        }
        return ""
    }
    
    var photoUrl: String {
        if let photoUrl = _latestDocument?.get(kUserPhotoUrl) {
            return photoUrl as! String
        }
        return ""
    }
    
    func updateName(name: String) {
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserName: name,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Name successfully updated")
            }
        }
    }
    
    func updatePhotoUrl(photoUrl: String) {
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserPhotoUrl: photoUrl,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("PhotoUrl successfully updated")
            }
        }
    }
}





