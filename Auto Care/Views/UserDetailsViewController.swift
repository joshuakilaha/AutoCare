//
//  UserDetailsViewController.swift
//  Auto Care
//
//  Created by JJ Kilz on 23/09/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    
    var user : User!

    @IBOutlet weak var fullNameLable: UILabel!
    @IBOutlet weak var firstNameLable: UILabel!
    @IBOutlet weak var lastNameLable: UILabel!
    @IBOutlet weak var userEmaillLable: UILabel!
    @IBOutlet weak var mobileNumberLable: UILabel!
    @IBOutlet weak var onBoardLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDetails()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func showDetails() {
        if user != nil {
            let phone = "0\(user.phoneNumber)"
            fullNameLable.text = user.fullName
            firstNameLable.text = user.firstName
            lastNameLable.text = user.lastName
            userEmaillLable.text = user.email
            mobileNumberLable.text = phone
            onBoardLable.text = String(user.onBoard)
        }
    }
    
    

}
