//
//  PurchaseHistoryTableViewController.swift
//  Auto Care
//
//  Created by Kilz on 07/03/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class PurchaseHistoryTableViewController: UITableViewController {

    //MARK: Vars
    
    var itemsArray: [Item] = []
    
    
    //Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
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
    
    
    //MARK: Functions
    
    private func loadItems() {
        
        downloadItemsWithIds(User.currentUser()!.purchasedItemIds) { (allItems) in
            
            self.itemsArray = allItems
            print("you have \(allItems.count) items purchased")
            self.tableView.reloadData()
        }
    }


   
}
