//
//  ItemTableViewCell.swift
//  Auto Care
//
//  Created by Kilz on 04/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit


class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameText: UILabel!
    @IBOutlet weak var itemDescriptionText: UILabel!
    @IBOutlet weak var itemPriceText: UILabel!
    
  
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateItemCell(_ item: Item) {
        itemNameText.text = item.itemName
        itemDescriptionText.text = item.description
        itemPriceText.text = convertCurrency(item.price)
        itemPriceText.adjustsFontSizeToFitWidth = true
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageurls: [item.imageLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }
}
