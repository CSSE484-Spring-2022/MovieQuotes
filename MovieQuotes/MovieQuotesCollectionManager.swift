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
    private init() {
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    var latestMovieQuotes = [MovieQuote]()
    
    func startListening() {
        // TODO: receive a changeListener
        
        let query = _collectionRef.order(by: kMovieQuoteLastTouched, descending: true).limit(to: 50)
        
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            for document in documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
    func stopListening() {
        // TODO: Implement
    }
    
    func add(_ mq: MovieQuote) {
        
    }
    
    func delete(_ documentId: String) {
        
    }
}
