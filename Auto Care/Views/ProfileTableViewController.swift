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
       
    @IBOutlet weak var myItemButton: UIButton!
    @IBOutlet weak var itemsinDB: UIButton!
    @IBOutlet weak var userDatabaseButton: UIButton!
    //MARK: VARS
      
    var editUIButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var myItemTableViewCell: UITableViewCell!
    
    @IBOutlet weak var myPurchaseHistoryTableCell:
    UITableViewCell!
    
    @IBOutlet weak var itemsInDBTableCell: UITableViewCell!
  
    
    @IBOutlet weak var databaseUsersTableCell: UITableViewCell!
    
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
          
           
           return 6
       }
    
    //MARK: Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

       
       //MARK: Functions
    
    
    private func checkOnBoadingStatus() {
        
        //AdminView()
        
        if User.currentUser() != nil {
            if User.currentUser()!.onBoard {
                finishedRegistrationOutlet.setTitle("Account is Active", for: .normal)
                finishedRegistrationOutlet.isEnabled = false
            } else {
                finishedRegistrationOutlet.setTitle("Finish Registration", for: .normal)
                finishedRegistrationOutlet.isEnabled = true
                finishedRegistrationOutlet.tintColor = .red
                
            }
            myPurchaseHistoryTableCell.isHidden = false
            myItemTableViewCell.isHidden = false
            
         //   itemsInDBTableCell.isHidden = false
            
            myItemButton.isEnabled = true
            purchaseHistoryButton.isEnabled = true
            itemsinDB.isEnabled = true
            userDatabaseButton.isEnabled = true
            
            
            if User.currentID() != AdminId {
                   itemsInDBTableCell.isHidden = true
                 databaseUsersTableCell.isHidden = true
               } else {
                   itemsInDBTableCell.isHidden = false
                  databaseUsersTableCell.isHidden = false
               }
            
        }
        else {
            finishedRegistrationOutlet.setTitle("logged Out", for: .normal)
            finishedRegistrationOutlet.isEnabled = false
            purchaseHistoryButton.isEnabled = false
            myItemButton.isEnabled = false
            itemsinDB.isEnabled = false
            userDatabaseButton.isEnabled = false
            myPurchaseHistoryTableCell.isHidden = true
            myItemTableViewCell.isHidden = true
            itemsInDBTableCell.isHidden = true
            databaseUsersTableCell.isHidden = true
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
        if editUIButtonItem.title == "Login" {
               //show login
            showLoginView()
            
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
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
    
    
    //MARK: ADMIN
    
    private func AdminView() {
    
        if User.currentID() != AdminId {
            itemsInDBTableCell.isHidden = true
            databaseUsersTableCell.isHidden = true
        } else {
            itemsInDBTableCell.isHidden = false
            databaseUsersTableCell.isHidden = false
        }
    }
}
