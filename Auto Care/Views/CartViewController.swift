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
    
    //MARK: PAYPAL
    
    var environment: String = PayPalEnvironmentNoNetwork {
        willSet (newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    
      
      let hud = JGProgressHUD(style: .light)
      
   // var automaticallyAdjustsScrollViewInsets: Bool { get set }
    
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPayPal()
        
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
    
    
    @IBAction func checkoutButton(_ sender: Any) {
    
        if User.currentUser()!.onBoard {
            payButtonPressed()
            
            //Proceed with Purchase
            
//             temp()
//            addItemsToPurchaseHistory(self.purchedItemsIds)
//            emptyTheCart()
            
        } else {
            
            self.hud.textLabel.text = "Please finish setting up your profile"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
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
            downloadItemsWithIdsForCart(cart!.itemIds) { (allItems) in
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
    
    private func setUpPayPal(){
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "AutoCare Limited"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        //setting up language
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both
        
    }
    
    //Payment
    
    private func payButtonPressed() {
        var itemsToBuy : [PayPalItem] = []
        for item in allItems {
            let tempItem = PayPalItem(name: item.itemName, withQuantity: 1, withPrice: NSDecimalNumber(value: item.price), withCurrency: "USD", withSku: nil)
            
            purchedItemsIds.append(item.id)
            itemsToBuy.append(tempItem)
                
        }
        
        let subTotal = PayPalItem.totalPrice(forItems: itemsToBuy)
        
        ////
        let shippingCost = NSDecimalNumber(string: "300.0")
        let tax = NSDecimalNumber(string: "50.0")
        
        let paymentDetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingCost, withTax: tax)
        
        let total = subTotal.adding(shippingCost).adding(tax)
        
        let payment  = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "payment to Autocare Limited", intent: .sale)
        
        payment.items = itemsToBuy
        payment.paymentDetails = paymentDetails
        
        if payment.processable {
            
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            
            present(paymentViewController!, animated: true, completion: nil)
        } else {
            print("Payment not Processed")
        }
    }
}

extension  CartViewController:  PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("payPal payment cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true) {
            
            self.addItemsToPurchaseHistory(self.purchedItemsIds)
            self.emptyTheCart()
        }
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
