//
//  CategoryCollectionViewCell.swift
//  AutoCare
//
//  Created by Kilz on 15/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var CategoryName: UILabel!
    
     func generateCategoryCell(_ category: Category) {
           CategoryName.text = category.name
           CategoryImage.image = category.image
       }
}
