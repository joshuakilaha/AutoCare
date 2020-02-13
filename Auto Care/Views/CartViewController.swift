//
//  CartViewController.swift
//  Auto Care
//
//  Created by Kilz on 13/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD

class CartViewController: UIViewController {

    @IBOutlet weak var CheckoutButtonPressed: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var priceLable: UILabel!

    

    

    //MARK: VARS
    
    
      var cart: Cart?
      var allItems: [Item] = []
      var purchedItemsIds: [String] = []
      
      let hud = JGProgressHUD(style: .light)
      
    
    
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CheckoutButtonPressed.layer.cornerRadius = 15
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: check is user is logged in
        downloadCart()
        
    }
    
    
    @IBAction func checkoutButton(_ sender: Any) {
        
    }
    
    
    //MARK: Functions
   
    private func downloadCart()  {
    
        downloadCartFromDatabase("1234567") { (cart) in
            self.cart = cart
            self.downloadItemsFormCart()
            
        }
    }
    
    
    private func downloadItemsFormCart() {
        
        if cart != nil {
            downloadItemsWithIdsForCart(cart!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalPrice(false)
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func updateTotalPrice(_ isEmpty: Bool) {
        if isEmpty {
            totalItems.text = "0"
            priceLable.text = showprice()
            
        } else {
            totalItems.text = "\(allItems.count)"
            priceLable.text = showprice()
        }
    }
    
    private func showprice() -> String {
        var totalprice = 0.0
         
        for item in allItems {
            totalprice += item.price
            
        }
        return "Total: " + convertCurrency(totalprice)
    }

}



//MARK: EXTENSIONS

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ItemTableViewCell
        
        cell.generateItemCell(allItems[indexPath.row])
        
        return cell
    }
    
    
}
