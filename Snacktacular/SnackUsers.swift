//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/27/20.
//

import Foundation
import Firebase

class SnackUsers {
    var userArray: [SnackUser] = []
    var db: Firestore!
    
    init () {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = [] //clean our existing spotArray
            for document in querySnapshot!.documents {
                //dictionary init
                let snackUser = SnackUser(dictionary: document.data())
                snackUser.documentID = document.documentID
                self.userArray.append(snackUser)
            }
            completed()
        }
    }
    
}
