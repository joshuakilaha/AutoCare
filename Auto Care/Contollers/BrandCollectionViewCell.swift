//
//  BrandCollectionViewCell.swift
//  Auto Care
//
//  Created by Kilz on 29/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandNameCell: UILabel!
    
    func generateBrandCell(_ brand: Brand) {
        brandNameCell.text = brand.brandName
        
        roundImage()
        
        if brand.imageLinks != nil && brand.imageLinks.count > 0 {
            downloadImages(imageurls: [brand.imageLinks.last!]) { (images) in
                self.brandImageView.image = images.last as? UIImage
            }
        }
        
    }
    
    
    func roundImage() {
        brandImageView.layer.cornerRadius = 15
       
    }
       
    }

