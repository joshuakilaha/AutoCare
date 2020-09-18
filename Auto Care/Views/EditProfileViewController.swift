//
//  EditProfileViewController.swift
//  Auto Care
//
//  Created by Kilz on 06/03/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD


class EditProfileViewController: UIViewController {

    
    //MARK: IBOutlets
    

    @IBOutlet weak var nametextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    let hud = JGProgressHUD(style: .light)
    
    //View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LoadUserInfo()
    }
    

   //MARK: IBActions
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkTextfield() {
            let withValues = [cFirstName: nametextField.text!, cLastName: surnameTextField.text!, cFullAddress: addressTextField.text!, cPhoneNumber: phoneNumber.text!, cFullName: (nametextField.text! + " " + surnameTextField.text!)]
            
            updateCurrentUserFromDatabase(withValues: withValues) { (error) in
                
                if error == nil {
                   self.hud.textLabel.text = "Your Details have been Updated"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                else {
                    print("Error while updating user", error!.localizedDescription)
                    self.hud.textLabel.text = error?.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        } else {
            hud.textLabel.text = "All Fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logOutUser()
        
        
    }
    
    
    //Place user Info in text
    
    private func LoadUserInfo() {
        if User.currentUser() != nil {
            let currentUser = User.currentUser()!
            
            let phone = "0\(currentUser.phoneNumber)"
            nametextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            phoneNumber.text = phone
            addressTextField.text = currentUser.fullAddress
        }
    }
    
    //Dismiss keyBoard
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func checkTextfield() -> Bool {
        
        return (nametextField.text != "" && surnameTextField.text != "" && addressTextField.text != "")
    }
    
    
    private func logOutUser() {
        User.logOutCurrentUser { (error) in
            if error == nil {
                print("Logged Out")
                
                self.hud.textLabel.text = "Logged out"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("There was an error logging out", error!.localizedDescription)
                
                self.hud.textLabel.text = "Failed to LogOut... Try agin later"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 5.0)
                
            }
        }
    }
}
