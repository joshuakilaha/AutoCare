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
      
   // var automaticallyAdjustsScrollViewInsets: Bool { get set }
    
    
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
        
        print("Checkout button Pressed")
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
        
        CheckoutButtonStatus()
    }
    
    private func showprice() -> String {
        var totalprice = 0.0
         
        for item in allItems {
            totalprice += item.price
            
        }
        return "Total: " + convertCurrency(totalprice)
    }
    
    
    
    //MARK: Button Status
    
    private func CheckoutButtonStatus() {
        
        CheckoutButtonPressed.isEnabled = allItems.count > 0
        
        if CheckoutButtonPressed.isEnabled {
            CheckoutButtonPressed.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        else {
                disableCheckoutButton()
        }
        
    }
    
    private func disableCheckoutButton () {
        CheckoutButtonPressed.isEnabled = false
        CheckoutButtonPressed.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    private func removeItemIdsFromCart(itemId: String) {
        
        for i in 0..<cart!.itemIds.count {
            
            if itemId == cart!.itemIds[i] {
                
                cart!.itemIds.remove(at: i)

            return
            }
        }
    }
    
    
    
       //MARK: Navigation
       
       private func showItemView(withItem: Item) {
           let itemVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
                  
                  itemVc.item = withItem
                  self.navigationController?.pushViewController(itemVc, animated: true)
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
    
    
    //showing ItemView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
        
        
    }
    
    
    
    //MARK: UITableView Delegate
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemIdsFromCart(itemId: itemToDelete.id)
            
            updateCartInDatabase(cart!, withValues: [cItemIds: cart!.itemIds]) { (error) in
                if error != nil {
                    print("error updating cart", error!.localizedDescription)
                }
                self.downloadItemsFormCart()
            }
            
        }
    }
    
    
}
