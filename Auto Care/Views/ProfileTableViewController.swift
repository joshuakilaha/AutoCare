//
//  ProfileTableViewController.swift
//  Auto Care
//
//  Created by Kilz on 05/03/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: IBOutlet
    
 
      @IBOutlet weak var finishedRegistrationOutlet: UIButton!
       
       @IBOutlet weak var purchaseHistoryButton: UIButton!
       
       //MARK: VARS
      
    var editUIButtonItem: UIBarButtonItem!
       
       //Life Cycle
       override func viewDidLoad() {
           super.viewDidLoad()

           tableView.tableFooterView = UIView()
    
           
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           //Check looged in status
        
        checkLoginStatus()
        checkOnBoadingStatus()
           
           
       }

       // MARK: - Table view data source


       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
           
           return 3
       }
    
    //MARK: Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

       
       //MARK: Functions
    
    
    private func checkOnBoadingStatus() {
        
        if User.currentUser() != nil {
            if User.currentUser()!.onBoard {
                finishedRegistrationOutlet.setTitle("Account is Active", for: .normal)
                finishedRegistrationOutlet.isEnabled = false
            } else {
                finishedRegistrationOutlet.setTitle("Finish Registration", for: .normal)
                finishedRegistrationOutlet.isEnabled = true
                finishedRegistrationOutlet.tintColor = .red
                
            }
        }
        else {
            finishedRegistrationOutlet.setTitle("logged Out", for: .normal)
            finishedRegistrationOutlet.isEnabled = false
            purchaseHistoryButton.isEnabled = false
        }
    }
       
    private func checkLoginStatus() {
        if User.currentUser() == nil {
            createRightBarButton(title: "Login")
        } else {
            createRightBarButton(title: "Edit")
        }
    }
    
    
    private func createRightBarButton(title: String) {
        
        editUIButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        
        self.navigationItem.rightBarButtonItem = editUIButtonItem
    }
    
    
    @objc func rightBarButtonPressed () {
        if editButtonItem.title == "Login" {
            
            //show login
        } else {
            //go to user profile
            goToEditProfile()
        }
    }
       
       // MARK: - Navigation

    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditProfile() {
        print("Edit profile")
    }
}
