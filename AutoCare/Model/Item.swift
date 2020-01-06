//
//  Item.swift
//  AutoCare
//
//  Created by Kilz on 20/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    var id: String!
    var brandId: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cObjectID] as? String
        brandId = _dictionary[cBrandID] as? String
        categoryId = _dictionary[cCategoryID] as? String
        name = _dictionary[cName] as? String
        description = _dictionary[cDescription] as? String
        price = _dictionary[cPrice] as? Double
        imageLinks = _dictionary[cImageLinks] as? [String]
        
    }
    
}

    
    //Create Item
    
func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.brandId, item.categoryId, item.name, item.description, item.price, item.imageLinks], forKeys: [cObjectID as NSCopying, cBrandID as NSCopying, cCategoryID as NSCopying, cName as NSCopying, cDescription as NSCopying, cPrice as NSCopying, cImageLinks as NSCopying])
    }


    //saving items
func saveItems(_ item: Item){
    FirebaseReference(.cITEMS_PATH).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}
    

    //Mark: download Items

func downloadItemsFromDatabase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void){
    
    var itemArray: [Item] = []
    
    FirebaseReference(.cITEMS_PATH).whereField(cCategoryID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            for itemDict in snapshot.documents {
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
        
    }
}
    
    
    

