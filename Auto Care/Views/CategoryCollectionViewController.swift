//
//  CategoryCollectionViewController.swift
//  Auto Care
//
//  Created by Kilz on 31/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {
    
    //MARK: Var
    
    var brand: Brand?
    var category: Category?
    
    var categoryArray: [Category] = []
    
    //Customizing Brand Cell
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
       
       private let categoriesPerRow: CGFloat = 3
    
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.title = brand?.brandName
        print("ID: ",brand!.id as Any)
        loadCategories()
       // emptyView()

        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        //emptyView()
//
//        loadCategories()
//
//    }
    
    //MARK: Functions
    
    @IBAction func addCategoryButton(_ sender: Any) {

        if User.currentUser() != nil {
            performSegue(withIdentifier: "toAddCategory", sender: self)
        } else  {
            self.showLoginView()
        }
        
    }
    
    
    private func showLoginView() {
          let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
          
          self.present(loginView, animated: true, completion: nil)
      }
    
            //MARK: Download Categories
    private func loadCategories() {
        downloadCategoryFromDatabase(brand!.id) { (allCategories) in
            print("Categories are", allCategories.count)
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toAddCategory" {
                   let toAddCategoryVC = segue.destination as! AddCategoryViewController
            toAddCategoryVC.brand = brand
        }
        
        if segue.identifier == "toItemsSegue" {
            
            let toItemsTableView = segue.destination as! ItemTableViewController
            toItemsTableView.brand = brand
            toItemsTableView.category = sender as! Category
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItemsSegue", sender: categoryArray[indexPath.row])
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
    
        cell.generateCategoryCell(categoryArray[indexPath.row])
        
        return cell
    }
    
//    private func emptyView() {
//        
//        if collectionView != nil {
//                loadCategories()
//                  print("There is an item")
//              }
//              else {
//            print("No item found")
//                  collectionView.emptyDataSetSource = self
//                  collectionView.emptyDataSetDelegate = self
//              }
//        
//    }

    

    
}

//MARK: EXTENSIONS


extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               let paddingSpace = sectionInsets.left * (categoriesPerRow + 1)
               let availableWidth = view.frame.width - paddingSpace
               let WidthPerItem = availableWidth / categoriesPerRow
               
               return CGSize(width: WidthPerItem, height: WidthPerItem)
           }
           
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
               return sectionInsets
           }
           
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
               return sectionInsets.left
           }
    
}

extension CategoryCollectionViewController: EmptyDataSetDelegate, EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No items in this category to be displayed")
    }
}
