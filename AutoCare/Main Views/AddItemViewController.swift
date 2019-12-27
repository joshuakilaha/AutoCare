//
//  AddItemViewController.swift
//  AutoCare
//
//  Created by Kilz on 21/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    //MARK: Vars
    var category: Category!
    var brand: Brand!
    
    var itemImages: [UIImage?] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func cameraButton(_ sender: Any) {
        
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkFieldsIfEmpty() {
            
            saveItem()
            
        }
        else {
            print("Please fill in all fields")
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    //Mark: saving items to Database 

    private func saveItem() {
        
         let item = Item()
                
                item.id = UUID().uuidString
                item.name = titleTextField.text!
                //item.brandId = brand.id
                item.categoryId = category.id
                item.description = descriptionTextView.text
                item.price = Double(priceTextField.text!)
                
                if itemImages.count > 0 {
                    
                } else {
                    saveItems(item)
                    popView()
                }
    }
    
    
    //helpers
    private func checkFieldsIfEmpty() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    // dismissing KeyBoard
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
     
    // moving back to tableviewController
    private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
