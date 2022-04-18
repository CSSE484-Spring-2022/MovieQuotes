//
//  MovieQuotesCollectionManager.swift
//  MovieQuotes
//
//  Created by David Fisher on 3/31/22.
//

import Foundation
import Firebase

class MovieQuotesCollectionManager {
    
    static let shared = MovieQuotesCollectionManager()
    var _collectionRef: CollectionReference
//    var listenerRegistration: ListenerRegistration?
    
    private init() {
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    var latestMovieQuotes = [MovieQuote]()
    
    func startListening(filterByAuthor authorFilter: String?, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        var query = _collectionRef.order(by: kMovieQuoteLastTouched, descending: true).limit(to: 50)
        if let authorFilter = authorFilter {
            print("TODO: filter by this author \(authorFilter)")
            query = query.whereField(kMovieQuoteAuthorUid, isEqualTo: authorFilter)
        }
        
        return query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.latestMovieQuotes.removeAll()
            for document in documents {
//                print("\(document.documentID) => \(document.data())")
                self.latestMovieQuotes.append(MovieQuote(documentSnapshot: document))
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    func add(_ mq: MovieQuote) {
        var ref: DocumentReference? = nil
        ref = _collectionRef.addDocument(data: [
            kMovieQuoteQuote: mq.quote,
            kMovieQuoteMovie: mq.movie,
            kMovieQuoteLastTouched: Timestamp.init(),
            kMovieQuoteAuthorUid: AuthManager.shared.currentUser!.uid
        ]) { err in
            if let err = err {
                print("Error adding document \(err)")
            } else {
                print("Document added with id \(ref!.documentID)")
            }
        }
    }
    
    func delete(_ documentId: String) {
        _collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
