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
