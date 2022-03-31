//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by David Fisher on 3/28/22.
//

import Foundation

class MovieQuote {
    var quote: String
    var movie: String
    var documentId: String?
    
    init(quote: String, movie: String) {
        self.quote = quote
        self.movie = movie
    }
}
