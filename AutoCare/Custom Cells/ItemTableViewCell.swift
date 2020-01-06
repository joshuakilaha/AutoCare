//
//  ItemTableViewCell.swift
//  AutoCare
//
//  Created by Kilz on 06/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    //Mark: IBOutlets
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var ItemNameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func generateCell(_ item: Item) {
        ItemNameLable.text = item.name
        descriptionLable.text = item.description
        priceLable.text = convertToCurrency(item.price)
        priceLable.adjustsFontSizeToFitWidth = true
        
    
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageurl: [item.imageLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage 
            }
        }
        
        
    }

}
