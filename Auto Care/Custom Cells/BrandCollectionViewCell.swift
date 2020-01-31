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
    @IBOutlet weak var brandName: UILabel!
    
   override func awakeFromNib(){
               super.awakeFromNib()
           }
     
    func generateBrandCell(_ brand: Brand) {
        brandName.text = brand.brandName
        //brandImageView.image = brand.brandImage 
        }
       
    }

