//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 3/29/22.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var authorBoxStackView: UIStackView!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    //    var movieQuote: MovieQuote!
    var movieQuoteDocumentId: String!
    
    var movieQuoteListenerRegistration: ListenerRegistration?
    var userListenerRegistration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print("TODO: Lister for the document with the id \(movieQuoteDocumentId)")
        
//        updateView()
    }
    
    func showOrHideEditButton() {
        if (AuthManager.shared.currentUser?.uid == MovieQuoteDocumentManager.shared.latestMovieQuote?.authorUid) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                target: self,
                                                                action: #selector(showEditQuoteDialog))
        } else {
            print("This is not your quote, don't allow edit")
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieQuoteListenerRegistration = MovieQuoteDocumentManager.shared.startListening(for: movieQuoteDocumentId!) {
            self.updateView()
            self.showOrHideEditButton()
            
            // Start listening for the User (author of this quote)
            self.authorBoxStackView.isHidden = true
            if let authorUid = MovieQuoteDocumentManager.shared.latestMovieQuote!.authorUid {
                UserDocumentManager.shared.stopListening(self.userListenerRegistration)
                self.userListenerRegistration = UserDocumentManager.shared.startListening(for: authorUid) {
                    self.updateAuthorBox()
                }
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuoteDocumentManager.shared.stopListening(movieQuoteListenerRegistration)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
    }
    
    func updateView() {
        //        quoteLabel.text = movieQuote.quote
        //        movieLabel.text = movieQuote.movie
        
        if let mq = MovieQuoteDocumentManager.shared.latestMovieQuote {
            quoteLabel.text = mq.quote
            movieLabel.text = mq.movie
        }
    }
    
    func updateAuthorBox() {
        print("TODO: Update the author box with name \(UserDocumentManager.shared.name)")
        print("TODO: Update the author box with photoUrl \(UserDocumentManager.shared.photoUrl)")
        
        self.authorBoxStackView.isHidden = UserDocumentManager.shared.name.isEmpty && UserDocumentManager.shared.photoUrl.isEmpty
        authorNameLabel.text = UserDocumentManager.shared.name
        
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: authorProfileImageView, from: UserDocumentManager.shared.photoUrl)
        }
        
    }
    
    
    @objc func showEditQuoteDialog() {
        let alertController = UIAlertController(title: "Edit movie quote",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            //            textField.text = self.movieQuote.quote
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.quote
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
            //            textField.text = self.movieQuote.movie
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.movie
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("You pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        // Positive button
        let editAction = UIAlertAction(title: "Edit Quote", style: UIAlertAction.Style.default) { action in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
            //            self.movieQuote.quote = quoteTextField.text!
            //            self.movieQuote.movie = movieTextField.text!
            //            self.updateView()
            
            MovieQuoteDocumentManager.shared.update(quote: quoteTextField.text!,
                                                    movie: movieTextField.text!)
        }
        alertController.addAction(editAction)
        present(alertController, animated: true)
    }
}
