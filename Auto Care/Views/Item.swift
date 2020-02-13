//
//  Item.swift
//  Auto Care
//
//  Created by Kilz on 04/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import UIKit


class Item {
    var id: String!
    var brandId: String!
    var categoryId: String!
    var itemName: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cObjectId] as? String
        brandId = _dictionary[cBrandId] as? String
        categoryId = _dictionary[cCategoryId] as? String
        itemName = _dictionary [cItemName] as? String
        description = _dictionary [cDesctiption] as? String
        price = _dictionary[cPrice] as? Double
        imageLinks = _dictionary[cImageLinks]  as? [String]
    }
    
}


                //MARK: Create Item

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    return NSDictionary(objects: [item.id, item.brandId, item.categoryId, item.itemName, item.description, item.price, item.imageLinks], forKeys: [cObjectId as NSCopying, cBrandId as NSCopying, cCategoryId as NSCopying, cItemName as NSCopying,cDesctiption as NSCopying, cPrice as NSCopying, cImageLinks as NSCopying])
}



            //MARK: Save item

func SaveItem(_ item: Item){
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}



            //MARK: Download Item

func downloadItemsFromDatabase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(cCategoryId, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            for itemDict in snapshot.documents {
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion (itemArray)
    }
    
}



//MARK: download items with ids for Cart

func downloadItemsWithIdsForCart(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var count = 0
    var itemArray : [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {
            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                
                if snapshot.exists {
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                } else {
                    completion(itemArray)
                }
                if count == withIds.count {
                    completion(itemArray)
                }
            }
        }
        
    } else {
        completion(itemArray)
    }
    
}



