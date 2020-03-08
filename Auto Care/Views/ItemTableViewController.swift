//
//  ItemTableViewController.swift
//  Auto Care
//
//  Created by Kilz on 04/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift


class ItemTableViewController: UITableViewController {
    
    //Mark: VAR
    
    var category: Category?
    var brand: Brand?
    var itemArray: [Item] = []

    
    
    //life Cycle
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.title = category?.categoryName
        print("BrandId is from Item Table is: ", brand!.id!)

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    

    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          if category != nil {
                     
                     //get items from database
                      downloadItem()
                 }
          
      }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ItemTableViewCell
        
        cell.generateItemCell(itemArray[indexPath.row])
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toAddItemSegue" {
            let toAddItemVC = segue.destination as! AddItemViewController
            toAddItemVC.brand = brand
            toAddItemVC.category = category
        }
    }
    
    private func showItemView(_ item: Item) {
        
        let itemVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVc.item = item
        itemVc.brand = brand
        itemVc.category = category
        self.navigationController?.pushViewController(itemVc, animated: true)
    }
    
    
    private func downloadItem() {
        downloadItemsFromDatabase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }

}





extension ItemTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Empty, No Items to be displayed!")
    }
    
    
    
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        retun UIImage(name: "") //select from assessts with name
//    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please refresh page or check later")
    }
}
