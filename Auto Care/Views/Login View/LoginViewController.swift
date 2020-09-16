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
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .circleStrokeSpin, color: #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1), padding: nil)
    }
    

 //MARK: IBACTIONS
    

    @IBAction func cancleButtonPressed(_ sender: Any) {
        
        dissmissView()
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
       
        if textFields() {
                  //Login users
                  loginUser()
                  
              } else {
                hud.textLabel.text = "ALL FIELDS ARE REQUIRED"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
        }
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
        if emailTextField.text != "" {
            
            resetThePassword()
            
        } else {
            hud.textLabel.text = "Please enter the email you want to reset"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    
    @IBAction func resendEmailPressed(_ sender: Any) {
        User.resendVerificationEmail(email: emailTextField.text!) { (error) in
            print("Error in resending email", error?.localizedDescription)
        }
    }
    
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
    dismissKeyboard()
    }
    
    
    
    //MARK: Functions
    
    
    //dismissing keyboard
     private func dismissKeyboard(){
        self.view.endEditing(false)
     }
    
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
    
    private func loginUser() {
        
        showLoadingIndicator()
        
        User.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if isEmailVerified {
                self.dissmissView()
                    print("Email is verified")
                }
                else {
                    
                    self.hud.textLabel.text = "Please Verify your Email!!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                    //enabling resend email button
                    self.resendButton.isHidden = false
                }
            }
            else {
                print("error logging in User", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
            
            self.hideLoadingIndicator()
        }
    }
    
    private func resetThePassword() {
      
        User.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Please check your email to reset password!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
            else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}
