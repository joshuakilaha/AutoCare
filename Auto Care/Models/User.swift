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
    var phoneNumber: String
    var purchasedItemIds: [String]
    var userItems: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    
    //MARK: Init
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String, _phoneNumber: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        phoneNumber = _phoneNumber
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
        userItems = []
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
        
        if let pnumber = _dictionary[cPhoneNumber]{
            phoneNumber = pnumber as! String
        } else {
            phoneNumber = ""
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
        
        if let useritemids = _dictionary[cUserItems] {
            userItems = useritemids as! [String]
        } else {
            userItems = []
        }
        
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
                    downloadUserFromDatabase(userId: authDataResult!.user.uid, email: email)
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
    
    
    //MARK: Reset Password

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
        
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("Was an Error in resnding Email", error?.localizedDescription)
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: cCurrentUser)
            UserDefaults.standard.synchronize()
            completion(nil)
        }
        catch let error as NSError {
            completion(error)
        }
    }
    
}

//MARK: Save user to Database

func saveUserToDatabase(muser: User) {
    FirebaseReference(.User).document(muser.objectId).setData(userDictionaryFrom(user: muser) as! [String : Any]) { (error)
        in
    
        if error != nil {
            print("error sating user \(error!.localizedDescription)")
        }
    }
}


//Current user
func  saveUserLocally(UsersDictionary: NSDictionary) {
    UserDefaults.standard.set(UsersDictionary, forKey: cCurrentUser)
    UserDefaults.standard.synchronize()
}



func userDictionaryFrom(user: User) -> NSDictionary {
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIds, user.userItems], forKeys: [cObjectId as NSCopying, cEmail as NSCopying, cFirstName as NSCopying, cLastName as NSCopying, cFullName as NSCopying, cFullAddress as NSCopying, cOnboard as NSCopying, cPurchasedItemIds as NSCopying, cUserItems as NSCopying])
}


//Getting Users from database

func downloadUserFromDatabase(userId: String, email: String) {
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            return
        }
        
        if snapshot.exists {
            
            print("getting the current user")
            saveUserLocally(UsersDictionary: snapshot.data()! as NSDictionary)
        }
        else {
            //No user, save new iin firestore
            
            let user = User(_objectId: userId, _email: email, _firstName: "", _lastName: "", _phoneNumber: "")
            saveUserLocally(UsersDictionary: userDictionaryFrom(user: user))
            saveUserToDatabase(muser: user)
            
        }
    }
    
}


//MARK: Update user

func updateCurrentUserFromDatabase(withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void) {
    
    if let dictionary = UserDefaults.standard.object(forKey: cCurrentUser) {
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(withValues)
        FirebaseReference(.User).document(User.currentID()).updateData(withValues) {
            (error) in
            completion(error)
            
            if error == nil  {
                saveUserLocally(UsersDictionary: userObject)
            }
        }
    }
}


//Gett Usets
func downloadAllUsers(completion: @escaping(_ usersArrary: [User]) -> Void){
    var usersArrary : [User] = []
    
    FirebaseReference(.User).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion (usersArrary)
            return
        }
        if !snapshot.isEmpty {
            for userDictionary in snapshot.documents {
                usersArrary.append(User(_dictionary: userDictionary.data() as NSDictionary))
            }
        }
        completion(usersArrary)
    }
}

