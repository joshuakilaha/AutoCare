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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func cameraButton(_ sender: Any) {
        
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkFieldsIfEmpty() {
            print("Values gotten")
        }
        else {
            print("Please fill in all fields")
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    //helpers
    
    private func checkFieldsIfEmpty() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
