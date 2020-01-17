//
//  ItemsTableViewController.swift
//  AutoCare
//
//  Created by Kilz on 20/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    //Mark: Vars
    
    var category: Category?
    var brand: Brand?
    
    var itemArray: [Item] = []
    
    //Mark: View life cycle
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
      //self.title = brand?.name
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            
            //get items from database
            
            downloadItems()
            
        }
    }
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])
        
        // Configure the cell...

        return cell
    }
    

    //MARK Table viewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemClicked(itemArray[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "itemToAddItemSegue" {
            
            let vc = segue.destination as! AddItemViewController
            vc.category = category
            
        }
    }
    
    private func showItemClicked(_ item: Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemUIViewController
        
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
    
    //Mark: LoadItems
    
    private func downloadItems(){
        
        downloadItemsFromDatabase(category!.id) { (allItems) in
            
            //print ("Number of items = \(allItems.count)")
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
    

}
