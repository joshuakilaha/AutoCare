//
//  ImageCollectionViewCell.swift
//  AutoCare
//
//  Created by Kilz on 17/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage 
    }
}
