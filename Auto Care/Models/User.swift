//
//  User.swift
//  Auto Care
//
//  Created by Kilz on 26/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    
    //MARK: Init
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary[cObjectId] as! String
        
        if let mail = _dictionary[cEmail] {
            email = mail as! String
        }
        else {
            email = ""
        }
        
        if let fname = _dictionary[cFirstName] {
            firstName = fname as! String
        }
        else {
            firstName = ""
        }
        
        if let lname = _dictionary[cLastName] {
            lastName = lname as! String
        }
        else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        
        if let faddress = _dictionary[cFullAddress] {
         fullAddress = faddress as! String
        }
        else {
            fullAddress = ""
        }
        
        if let onB = _dictionary[cOnboard] {
            onBoard = onB as! Bool
        }
        else {
            onBoard = false
        }
        
        
        if let purchaedids = _dictionary[cPurchasedItemIds] {
         purchasedItemIds = purchaedids as! [String]
        }
        else {
            purchasedItemIds = []
        }
        
    }
    
    
    
    //MARK: return Current User
    
    class func currentID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
    
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: cCurrentUser) {
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    
  
    
    
                //MARK: SignUp User

    class func signUpUserwith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("Authentication Email Verification Error: ", error?.localizedDescription)
                }
                
            }
        }
    }
    
    
    
    
            //MARK: LOGIN
      
      class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
          Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
              
              if error  == nil {
                  if authDataResult!.user.isEmailVerified {
                      
                      //Download User From Database
                      completion(error, true)
                      
                      
                  } else {
                      print("Email not Verified")
                      completion(error, false)
                  }
              } else {
                  
                  completion(error, false)
              }
          }
      }
}
