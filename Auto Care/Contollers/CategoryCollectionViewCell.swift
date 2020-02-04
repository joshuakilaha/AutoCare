//
//  CategoryCollectionViewCell.swift
//  Auto Care
//
//  Created by Kilz on 29/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    
    func generateCategoryCell(_ category: Category){
        categoryName.text = category.categoryName
        
        if category.imageLinks != nil && category.imageLinks.count > 0 {
            downloadImages(imageurls: [category.imageLinks.last!]) { (images) in
                self.categoryImageView.image = images.last as? UIImage
            }
        }
    }
    
}
