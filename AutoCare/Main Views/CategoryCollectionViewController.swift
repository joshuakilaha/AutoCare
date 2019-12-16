//
//  CategoryCollectionViewController.swift
//  AutoCare
//
//  Created by Kilz on 15/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
     
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   
}
