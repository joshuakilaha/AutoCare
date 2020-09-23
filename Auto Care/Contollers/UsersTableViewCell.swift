//
//  UsersTableViewCell.swift
//  Auto Care
//
//  Created by JJ Kilz on 23/09/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var phoneNumberLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateUsersDetail(_ user: User){
        
         let phone = "0\(user.phoneNumber)"
        
        userNameLable.text = user.fullName
        emailLable.text = user.email
        phoneNumberLable.text = phone
    }

}
