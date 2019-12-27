//
//  BrandCollectionViewCell.swift
//  AutoCare
//
//  Created by Kilz on 14/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var BrandImageView: UIImageView!
    @IBOutlet weak var BrandName: UILabel!
    
    
    
    
    func generateBrandCell(_ brand: Brand) {
        BrandName.text = brand.name
        BrandImageView.image = brand.image
        
    }
    
}
