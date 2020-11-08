//
//  Reviews.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/7/20.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
}
