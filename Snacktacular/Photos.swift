//
//  Photos.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/13/20.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        guard spot.documentID != "" else {
            return
        }
        
        db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = [] //clean our existing photoArray
            for document in querySnapshot!.documents {
                //dictionary init
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
            }
            completed()
        }
    }
    
}

