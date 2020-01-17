//
//  ItemUIViewController.swift
//  AutoCare
//
//  Created by Kilz on 16/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemUIViewController: UIViewController {

    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //Mark VARS
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .light)
    
     private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    private let cellHeight : CGFloat = 196.0
    
    private let itemsPerRow: CGFloat = 1
    
    //Mark View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        downloadPictures()
    }
    
    //Mark Download pictures
    
    private func downloadPictures(){
        
        if item != nil && item.imageLinks != nil {
            downloadImages(imageurl: item.imageLinks) { (allImages) in
                
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
        
    }
    
    private func setupUI(){
        
        if item != nil {
            self.title = item.name
            nameLable.text = item.name
            priceLable.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }

}


extension ItemUIViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            
             cell.setupImageWith(itemImage: itemImages[indexPath.row])
              
        }
    
        return cell
    }

}


extension ItemUIViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        let availableWidth = collectionView.frame.width - sectionInsets.left
           
           return CGSize(width: availableWidth, height: cellHeight)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return sectionInsets
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return sectionInsets.left
       }
}


