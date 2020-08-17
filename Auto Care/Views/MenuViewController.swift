//
//  MenuViewController.swift
//  Auto Care
//
//  Created by JJ Kilz on 02/08/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class MenuViewController: UIViewController {
    
    //MARK: VAR
    
    //Brand
       var BrandArray: [Brand] = []
       var brand: Brand?
    
    //Category
    
    
    //Items

    
    
    //NVAIndicator
    var activityIndicator: NVActivityIndicatorView?
    
    
    //Customizing Brand Cell
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let brandsPerRow: CGFloat = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.width / 1 - 50, width: 80, height: 80), type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), padding: nil)
          
          if BrandArray != nil {
              showLoadingindicator()
               downloadBrands()
              hideLoadIndicator()
              } else {
              print("No Brand")
          }
      }
    
    
//MARK: Loading Indicator
       
       //show indicator
       private func showLoadingindicator() {
           if activityIndicator != nil {
               self.view.addSubview(activityIndicator!)
               activityIndicator!.startAnimating()
           }
       }
       
       
       //hide indicator
       
       private func hideLoadIndicator() {
           
           if activityIndicator != nil {
               activityIndicator!.removeFromSuperview()
               activityIndicator!.stopAnimating()
           }
       }
    
    
    
                //MARK:  - FUNCTIONS
    
    //Download Brands
    
    private func downloadBrands(){
        
      //  showLoadingindicator()
        
        downloadBrandFromDatabase { (allBrands) in
            print("Brands are", allBrands.count)
            self.BrandArray = allBrands
           // self.collectionView.reloadData()
            
            // self.hideLoadIndicator()
            
        }
    }
    
       //Download Categories
    
    
    
    
       //Download Items
    
}


extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let paddingSpace = sectionInsets.left * (brandsPerRow + 1)
         let availableWidth = view.frame.width - paddingSpace
         let widthPerItem = availableWidth / brandsPerRow
         
         return CGSize(width: widthPerItem, height: widthPerItem)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                 
         return sectionInsets
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return sectionInsets.left
     }
}
