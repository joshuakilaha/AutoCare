//
//  Cart.swift
//  Auto Care
//
//  Created by Kilz on 07/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation

class Cart {
    
    var id: String!
    var itemIds: [String]!
    var categoryId: String!
    var brandId: String!
    var userId: String!
    
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary [cObjectId] as? String
        itemIds = _dictionary [cItemIds] as? [String]
        categoryId = _dictionary [cCategoryId] as? String
        brandId = _dictionary [cBrandId] as? String
        userId = _dictionary [cUserId] as? String
    }
    
}



            //MARK: CREATING CART

func cartDictionaryFrom(_ cart: Cart) -> NSDictionary {
    return NSDictionary(objects: [cart.id, cart.itemIds, cart.categoryId, cart.brandId, cart.userId], forKeys: [cObjectId as NSCopying, cItemIds as NSCopying, cCategoryId as NSCopying, cBrandId as NSCopying, cUserId as NSCopying])
}





                //MARK: SAVING CART TO DATABASE

func savingCartToDatabase(_ cart: Cart) {
    
    FirebaseReference(.Cart).document(cart.id).setData(cartDictionaryFrom(cart) as! [String: Any])
    
}


//MARK: DOWNLOAD CART FROM DATABASE

func downloadCartFromDatabase(_ userid: String, completion: @escaping (_ cart: Cart?) -> Void ) {
    
    FirebaseReference(.Cart).whereField(cUserId, isEqualTo: userid).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let cart = Cart(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(cart)
        } else {
            completion(nil)
        }
    }
    
}


        //MARK: UPDATE CART

func updateCartInDatabase(_ cart: Cart, withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void){
    
    FirebaseReference(.Cart).document(cart.id).updateData(withValues) { (error) in
        completion(error)
    }
}

