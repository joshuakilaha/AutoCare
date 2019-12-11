//
//  CategoryCollectionViewController.swift
//  AutoCare
//
//  Created by Kilz on 05/12/2019.
//  Copyright © 2019 joshua kilaha. All rights reserved.
//

import UIKit



class CategoryCollectionViewController: UICollectionViewController {
    
    var categoryArray: [Category] = []
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)

    private let itemsPerRow: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCategories()
    }
   

    // MARK: UICollectionViewDataSource

  

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for:
            indexPath) as! CategoryCollectionViewCell
    
        cell.generateCell(categoryArray[indexPath.row])
    
        return cell
    }

    //Retriving categories
    private func loadCategories() {
        getCategoriesFromFirebase { (allCategories) in
            print("categories = ",allCategories.count)
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    

}


extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout{
    
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
