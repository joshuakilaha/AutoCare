//
//  BrandCollectionViewController.swift
//  AutoCare
//
//  Created by Kilz on 14/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit


class BrandCollectionViewController: UICollectionViewController {
    
    
    //Mark: UIViewRadius
    
    @IBOutlet weak var ContentUIView: UIView!
    
    //Mark: vars
   var BrandArray: [Brand] = []
    
   private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)

    private let itemsPerRow: CGFloat = 3

    

        //Mark: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //createBrandSet()
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBrands()
    }

    
        // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return BrandArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCollectionViewCell
        
        cell.generateBrandCell(BrandArray[indexPath.row])
        
        return cell
       
    }
    
    
    
    
    //Mark: UICOllectionView Delegate
    
    //Brand Clicked
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "brandToCategorySegue", sender: BrandArray[indexPath.row])
        
    }
    
    //Mark: Navigation calling the item from segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "brandToCategorySegue" {
            let vc = segue.destination as! CategoryCollectionViewController
            vc.brand  =  sender as! Brand
            
        }
        
    }
    
    
    

    
    
        //Mark: Download Brands
    private func loadBrands(){
        getBrandFromFirebase { (allBrands) in
            print("Brands are", allBrands.count)
            self.BrandArray = allBrands
            self.collectionView.reloadData()
        }
    }
}


extension BrandCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
           let availableWidth = view.frame.width - paddingSpace
           let WidthPerItem = availableWidth / itemsPerRow
           
           return CGSize(width: WidthPerItem, height: WidthPerItem)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return sectionInsets
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return sectionInsets.left
       }
    
}
