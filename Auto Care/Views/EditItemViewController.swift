//
//  EditItemViewController.swift
//  Auto Care
//
//  Created by JJ Kilz on 22/09/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    //MARK: VARS
    
    var brand: Brand!
    var category: Category!
    var item: Item!
 
    @IBOutlet weak var itemNameTextField: UITextField!
    
    
    @IBOutlet weak var ItemPriceTextFied: UITextField!
    
    
    @IBOutlet weak var itemDescription: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadItem()
    }
    
    
    @IBAction func updateButton(_ sender: Any) {
        
        var p = Double(ItemPriceTextFied.text!)
        
        if checkTextfield() {
            let itemsToEdit = [cItemName: itemNameTextField.text!, cPrice: p as Any, cDesctiption: itemDescription.text!] as [String : Any]
            
            FirebaseReference(.Items).document(item.id).updateData(itemsToEdit){ error in
                if let error = error {
                    print("Error Updating Item \(error)")
                } else {
                    print("Document Updated Sucessfully")
                }
            }
        }
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        
        
    }
    
    private func loadItem() {
        
        
        if item != nil {
            itemNameTextField.text = item.itemName
            ItemPriceTextFied.text = convertCurrency(item.price)
            itemDescription.text = item.description
            
            
        }
    }
    
    
    private func checkTextfield() -> Bool {
          
          return (itemNameTextField.text != "" && itemDescription.text != "")
      }
    
}
