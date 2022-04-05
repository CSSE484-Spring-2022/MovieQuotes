//
//  MovieQuoteDocumentManager.swift
//  MovieQuotes
//
//  Created by David Fisher on 3/31/22.
//

import Foundation
import Firebase

class MovieQuoteDocumentManager {

    var latestMovieQuote : MovieQuote?
    static let shared = MovieQuoteDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = _collectionRef.document(documentId)
        
        return query.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard document.data() != nil else {
              print("Document data was empty.")
              return
            }
//            print("Current data: \(data)")
            self.latestMovieQuote = MovieQuote(documentSnapshot: document)
            changeListener()
          }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        print("Removing the listener")
        listenerRegistration?.remove()
    }
    
    
    func update(quote: String, movie: String) {
        _collectionRef.document(latestMovieQuote!.documentId!).updateData([
            kMovieQuoteQuote: quote,
            kMovieQuoteMovie: movie,
            kMovieQuoteLastTouched: Timestamp.init(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}




