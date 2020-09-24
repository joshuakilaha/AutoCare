//
//  MyItemsTableViewController.swift
//  Auto Care
//
//  Created by JJ Kilz on 19/09/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class MyItemsTableViewController: UITableViewController {
    
    
    var itemsArray: [Item] = []
    var category: Category?
      var brand: Brand?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }
    
    
    
//    private func showItemView(_ item: Item) {
//
//        let itemVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
//
//        itemVc.item = item
//        itemVc.brand = brand
//        itemVc.category = category
//        self.navigationController?.pushViewController(itemVc, animated: true)
//    }
    
    
    
    private func showItemView(_ item: Item) {
         
         let itemVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "editItemView") as! EditItemViewController
         
         itemVc.item = item
         itemVc.brand = brand
         itemVc.category = category
         self.navigationController?.pushViewController(itemVc, animated: true)
     }
    
    

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ItemTableViewCell

        cell.generateItemCell(itemsArray[indexPath.row])

        return cell
    }
    
    
     //MARK: Table view delegate
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         showItemView(itemsArray[indexPath.row])
     }
     
    
    //Deleting Item
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               
             
             let itemToDelete = itemsArray[indexPath.row]
             itemsArray.remove(at: indexPath.row)
             tableView.reloadData()
             
             deleteItemFromDB(itemToDelete)
         }
       }
    
    //MARK: Functions
    
    private func loadItems() {
           
        downloadItemsWithIds(User.currentUser()!.userItems) { (allItems) in
               
               self.itemsArray = allItems
               print("you have \(allItems.count) added to Auto Care")
               self.tableView.reloadData()
           }
       }
}

extension MyItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
                return NSAttributedString(string: "You have not any Item to Auto Care")

    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
         return UIImage(named: "Auto Care")
    }
}
