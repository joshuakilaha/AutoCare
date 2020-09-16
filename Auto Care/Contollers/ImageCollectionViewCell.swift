//
//  ImageCollectionViewCell.swift
//  Auto Care
//
//  Created by Kilz on 06/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit



class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewItem: UIImageView!
    
    func setUpItemImageView(itemImage: UIImage) {
        imageViewItem.image = itemImage
    }
}
