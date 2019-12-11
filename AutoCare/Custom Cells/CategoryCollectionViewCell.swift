//
//  CategoryCollectionViewCell.swift
//  AutoCare
//
//  Created by Kilz on 05/12/2019.
//  Copyright © 2019 joshua kilaha. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    
    func generateCell(_ category: Category) {
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
    
}
