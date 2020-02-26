//
//  LoginViewController.swift
//  Auto Care
//
//  Created by Kilz on 21/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    //MARK: Outlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    
    
    
    //MARK: VARS
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), padding: nil)
    }
    

 //MARK: IBACTIONS
    

    @IBAction func cancleButtonPressed(_ sender: Any) {
        
        dissmissView()
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dissmissView()
    }
    
    
    @IBAction func signUpbuttonPressed(_ sender: Any) {
        
        if textFields() {
            //register user
            
            signUpUser()
            
        }
        else {
            hud.textLabel.text = "ALL FIELDS ARE REQUIRED"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        
    }
    
    
    @IBAction func resendEmailPressed(_ sender: Any) {
    }
    
    
    
    //MARK: Functions
    
    
    private func textFields() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dissmissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    //MARK: USER SIGNUP
    private func signUpUser() {
        
        showLoadingIndicator()
        
        User.signUpUserwith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Email Verification sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            else {
                print("error registering", error!.localizedDescription)
                self.hud.textLabel.text = "Registration Failed!!"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
             self.hideLoadingIndicator()
        }
        
       
        
    }
    
}
