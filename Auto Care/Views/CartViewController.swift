//
//  CartViewController.swift
//  Auto Care
//
//  Created by Kilz on 13/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe

class CartViewController: UIViewController {

    @IBOutlet weak var CheckoutButtonPressed: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var priceLable: UILabel!

    

    

    //MARK: VARS
    
    
    var cart: Cart?
    var allItems: [Item] = []
    var purchedItemsIds: [String] = []
    var totalPrice = 0
  
    
      
      let hud = JGProgressHUD(style: .light)
      
   // var automaticallyAdjustsScrollViewInsets: Bool { get set }
    
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
       // table.tableFooterView = footerView
        
        CheckoutButtonPressed.layer.cornerRadius = 15
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.currentUser() != nil {
            downloadCart()
        }
        else {
            self.updateTotalPrice(true)
        }
    }
    
    
    @IBAction func checkOutButton(_ sender: Any) {
    
        if User.currentUser()!.onBoard {
            //show action
            showPaymentOptions()
       //  finishPayment(tokken: <#T##STPToken#>)
            
            
        } else {
            self.showNotification(text: "Please finish setting up your profile", isError: true)
        }
        print("Checkout button Pressed")
    }
    
    
                        //MARK: Functions
   
    private func downloadCart()  {
    
        
        downloadCartFromDatabase(User.currentID()) { (cart) in
            self.cart = cart
            self.downloadItemsFormCart()
            
        }
    }
    
    
    private func downloadItemsFormCart() {
        
        if cart != nil {
            downloadItemsWithIds(cart!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalPrice(false)
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func emptyTheCart() {
        purchedItemsIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        cart!.itemIds = []
        
        updateCartInDatabase(cart!, withValues: [cItemIds: cart!.itemIds]) { (error) in
            if error != nil {
                print("Error Updating Cart", error!.localizedDescription)
            } else {
                self.downloadItemsFormCart()
            }
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        if User.currentUser() != nil {
            let newItemIds = User.currentUser()!.purchasedItemIds + itemIds
            updateCurrentUserFromDatabase(withValues: [cPurchasedItemIds: newItemIds]) { (error) in
                
                if error != nil {
                    print("Error adding purchased items", error!.localizedDescription)
                }
            }
    }
}
    
//    func temp() {
//        for item in allItems {
//            purchedItemsIds.append(item.id)
//        }
//    }
    
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
       

    //
    
 
    
    //Payment
    
    private func finishPayment(tokken: STPToken) {
        self.totalPrice = 0
        for item in allItems {
            purchedItemsIds.append(item.id)
            self.totalPrice += Int(item.price)
        }
        self.totalPrice = self.totalPrice * 100
        StripeClient.sharedClient.createAndConfirmPayment(tokken, amount: totalPrice) { (error) in
            if error == nil {
                self.emptyTheCart()
                self.addItemsToPurchaseHistory(self.purchedItemsIds)
                //show notification
                self.showNotification(text: "Payment Successful", isError: false)
            } else {
                self.showNotification(text: error!.localizedDescription, isError: true)
                print("error", error!.localizedDescription)
            }
        }
    }
    
    
    private func showNotification(text: String, isError: Bool) {
         if isError {
              self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
         } else {
              self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
         }
         self.hud.textLabel.text = text
         self.hud.show(in: self.view)
         self.hud.dismiss(afterDelay: 2.0)
     }
     private func showPaymentOptions() {
         let alertController = UIAlertController(title: "Payment Options", message: "Choose your method of payment", preferredStyle: .actionSheet)
        
         let CardAtion = UIAlertAction(title: "Pay with Visa Card", style: .default) { (action) in
            
             //show card
             let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "visaCard") as! CardInfoViewController
            
             vc.delegate = self
            
             self.present(vc, animated: true, completion: nil)
         }
         
         let Mpesa = UIAlertAction(title: "Pay with Mpesa", style: .default) { (action) in
                    //show card
                }
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
         alertController.addAction(CardAtion)
         alertController.addAction(Mpesa)
         alertController.addAction(cancelAction)
         
         present(alertController, animated: true, completion: nil)
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


extension CartViewController: CardInfoViewControllerDelaget {
    func didClickDone(_ token: STPToken) {
        finishPayment(tokken: token)
    }
    
    func didClickCancel() {
        showNotification(text: "Payment Canceled", isError: true)
    }
    
    
}
