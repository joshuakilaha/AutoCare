//
//  FinishRegistrationViewController.swift
//  Auto Care
//
//  Created by Kilz on 06/03/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

    
    //MARK: OutLets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    let hud = JGProgressHUD(style: .light)

    //Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

            
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange (_:)), for: UIControl.Event.editingChanged)
        
        SurnameTextField.addTarget(self, action: #selector(self.textFieldDidChange (_:)),
        for: UIControl.Event.editingChanged)
        
        AddressTextField.addTarget(self, action: #selector(self.textFieldDidChange (_:)),
        for: UIControl.Event.editingChanged)
        
        phoneNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for:UIControl.Event.editingChanged)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {

        finishOboarding()
        
    }
    
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            
        print("text did change")
        
        updateDoneButtonStatus()
    }
    
    
    //MARK:
    private func updateDoneButtonStatus() {
        if nameTextField.text != "" && SurnameTextField.text != "" && AddressTextField.text != "" {
            
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1)
            doneButtonOutlet.isEnabled = true
            
        }
        else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            doneButtonOutlet.isEnabled = false
        }
    }
    
    private func finishOboarding (){
        let withValues = [cFirstName: nameTextField.text!, cLastName: SurnameTextField.text!, cOnboard: true, cFullAddress: AddressTextField.text!,cPhoneNumber: phoneNumberTextField.text!, cFullName: (nameTextField.text! + " " + SurnameTextField.text!)] as [String: Any]
        
        updateCurrentUserFromDatabase(withValues: withValues) { (error) in
            if error == nil {
                  self.hud.textLabel.text = "Updated!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
                
            }else {
                print("Error updatng user \(error!.localizedDescription)")
                
                self.hud.textLabel.text = error?.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
}
