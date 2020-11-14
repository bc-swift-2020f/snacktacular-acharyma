//
//  Photo.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/13/20.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        
        return ["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL": photoURL]
    }
    
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String) {
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
    }
    
    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? ""
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        
        
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        //convert photo.image to a Data type to store
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("ERROR: Couldn't convert photo.image to Data")
            return
        }
        
        //create metadata so we see images in Firebase Storage Console
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create a filename if necessary
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        //create storage ref
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        //create upload task
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
            if let error = error {
                print("ERROR: upload for ref \(uploadMetaData) failred. \(error.localizedDescription)")
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("Upload to firebase storage was successful!")
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    print("ERROR: couldn't create download URL")
                    return completion(false)
                }
                guard let url = url else {
                    print("ERROR: URL was nil")
                    return completion(false)
                }
                self.photoURL = "\(url)"
                
                //Create the dictionary representing data we want to save
                let dataToSave: [String: Any] = self.dictionary
                
                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("ERROR: updating document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    
                    print("Updated document: \(self.documentID) in spot: \(spot.documentID)") //It worked!!
                    completion(true)
                }
                
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("ERROR: upload task for file \(self.documentID) failed, in spot \(spot.documentID), with error \(error.localizedDescription)")
            }
            completion(false)
        }
    }
    
    func loadImage(spot: Spot, completion: @escaping (Bool) -> ()) {
        guard spot.documentID != "" else {
            print("ERROR: did not pass a valid spot into loadImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        storageRef.getData(maxSize: 25 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROR: an error occured while reading data file from file ref \(storageRef) error = \(error.localizedDescription)")
                return completion(false)
            }
            else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
}
