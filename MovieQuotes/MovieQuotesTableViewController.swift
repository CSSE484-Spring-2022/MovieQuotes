//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 3/28/22.
//

import UIKit

class MovieQuoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var movieLabel: UILabel!
    
}

class MovieQuotesTableViewController: UITableViewController {
    
    let kMovieQuoteCell = "MovieQuoteCell"
    let kMovieQuoteDetailSegue = "MovieQuoteDetailSegue"
    
//    let names = ["Dave", "Kristy", "McKinley", "Keegan", "Bowen", "Neala"]
    var movieQuotes = [MovieQuote]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showAddQuoteDialog))
        
        // Hardcode some movie quotes
        
        
        let mq1 = MovieQuote(quote: "I'll be back", movie: "The Terminator")
        let mq2 = MovieQuote(quote: "Yo Adrian", movie: "Rocky")
        let mq3 = MovieQuote(quote: "Hello. My name is Inigo Montoya. You killed my father. Prepare to die!",
                             movie: "The Princess Bride")
        movieQuotes.append(mq1)
        movieQuotes.append(mq2)
        movieQuotes.append(mq3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieQuotesCollectionManager.shared.startListening()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuotesCollectionManager.shared.stopListening()
    }
    
    @objc func showAddQuoteDialog() {
        let alertController = UIAlertController(title: "Create a new movie quote",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("You pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        // Positive button
        let createQuoteAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { action in
            print("You pressed create quote")
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.append(mq)
            self.movieQuotes.insert(mq, at: 0)
            self.tableView.reloadData()
        }
        alertController.addAction(createQuoteAction)
        
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieQuotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell

        // Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.row)"
//        cell.textLabel?.text = names[indexPath.row]
        
//        cell.textLabel?.text = movieQuotes[indexPath.row].quote
//        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie

        cell.quoteLabel.text = movieQuotes[indexPath.row].quote
        cell.movieLabel.text = movieQuotes[indexPath.row].movie
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMovieQuoteDetailSegue {
            let mqdvc = segue.destination as! MovieQuoteDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                mqdvc.movieQuote = movieQuotes[indexPath.row]
            }
        }
    }
}
