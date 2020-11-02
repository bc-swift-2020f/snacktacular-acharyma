//
//  Spots.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/2/20.
//

import Foundation
import Firebase

class Spots {
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init () {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = [] //clean our existing spotArray
            for document in querySnapshot!.documents {
                //dictionary init
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
    
}
