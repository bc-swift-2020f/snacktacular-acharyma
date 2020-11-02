//
//  Spot.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/1/20.
//

import Foundation

class Spot {
    var name: String
    var address: String
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    init(name: String, address: String, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
}
