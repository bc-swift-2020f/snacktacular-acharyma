//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by Manogya Acharya on 11/13/20.
//

import UIKit

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    var spot: Spot!
    
    var photo: Photo! {
        didSet {
            print("THIS MEANS THIS SET WAS TRIGGERED")
            photo.loadImage(spot: spot) { (success) in
                if success {
                    self.photoImageView.image = self.photo.image
                    print("image loaded")
                }
                else {
                    print("ERROR: error loading image in SpotPhotoCollectionViewCell")
                }
            }
        }
    }
}
