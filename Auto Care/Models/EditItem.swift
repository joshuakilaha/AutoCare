////
////  EditItem.swift
////  Auto Care
////
////  Created by JJ Kilz on 22/09/2020.
////  Copyright © 2020 Kilz. All rights reserved.
////
//
//import Foundation
//
//class EditItem {
//
//    var id: String!
//    var brandId: String!
//    var categoryId: String!
//    var itemName: String!
//    var description: String!
//    var price: Double!
//    var imageLinks: [String]!
//    var userId: String!
//    var owner: String!
//    var phoneNumber: String!
//
//
//init(_id: String, _brandId: String, _categoryId: String,_itemName: String,_description: String, _price:Double,_owner: String, _phoneNumber: String) {
//
//    id = _id
//    brandId = _brandId
//    categoryId = _categoryId
//    itemName = _itemName
//    description = _description
//    price = _price
//    imageLinks = []
//    userId = ""
//    owner = _owner
//    phoneNumber = _phoneNumber
//
//}
//
//
//    init(_dictionary: NSDictionary) {
//        id = _dictionary[cObjectId] as? String
//        brandId = _dictionary[cBrandId] as? String
//        categoryId = _dictionary[cCategoryId] as? String
//
//        if let ItemName = _dictionary[cItemName] as? String {
//            itemName = ItemName as String
//        } else{
//            itemName = ""
//        }
//
//        if let desc = _dictionary[cDesctiption] as? String{
//            description = desc as String
//        } else {
//            description = ""
//        }
//
//        if let pr = _dictionary[cPrice] as? Double {
//            price = pr as Double
//        } else {
//            price = 0.0
//        }
//
//        if let phone = _dictionary[cPhoneNumber] as? String {
//            phoneNumber = phone as String
//        } else {
//            phoneNumber = ""
//        }
//
//
//      imageLinks = _dictionary[cImageLinks]  as? [String]
//        userId = _dictionary[cUserForItemId] as? String
//        owner = _dictionary[cFullName] as? String
//
//    }
//
//    class func currenItemID() -> String {
//        return
//    }
//
//    class func currentItem() -> EditItem? {
//        let item : EditItem
//
//        if item.id != nil {
//            if let dictiona
//        }
//    }
//
//}
//
//
//
//
//
//
//// // Item.swift
//////  Auto Care
//////
//////  Created by Kilz on 04/02/2020.
//////  Copyright © 2020 Kilz. All rights reserved.
//////
////
////import Foundation
////import UIKit
////import InstantSearchClient
////import FirebaseAuth
////
////class Item {
////    var id: String!
////    var brandId: String!
////    var categoryId: String!
////    var itemName: String!
////    var description: String!
////    var price: Double!
////    var imageLinks: [String]!
////    var userId: String!
////    var owner: String!
////    var phoneNumber: String!
////
////    init(_id: String, _brandId: String, _categoryId: String,_itemName: String,_description: String, _price:Double,_owner: String, _phoneNumber: String) {
////
////        id = _id
////        brandId = _brandId
////        categoryId = _categoryId
////        itemName = _itemName
////        description = _description
////        price = _price
////        imageLinks = []
////        userId = ""
////        owner = _owner
////        phoneNumber = _phoneNumber
////
////    }
////
////    init(_dictionary: NSDictionary) {
////        id = _dictionary[cObjectId] as? String
////        brandId = _dictionary[cBrandId] as? String
////        categoryId = _dictionary[cCategoryId] as? String
////
////        if let ItemName = _dictionary[cItemName] as? String {
////            itemName = ItemName as String
////        } else{
////            itemName = ""
////        }
////
////        if let desc = _dictionary[cDesctiption] as? String{
////            description = desc as String
////        } else {
////            description = ""
////        }
////
////        if let pr = _dictionary[cPrice] as? Double {
////            price = pr as Double
////        } else {
////            price = 0.0
////        }
////
////        if let phone = _dictionary[cPhoneNumber] as? String {
////            phoneNumber = phone as String
////        } else {
////            phoneNumber = ""
////        }
////
////
////      imageLinks = _dictionary[cImageLinks]  as? [String]
////        userId = _dictionary[cUserForItemId] as? String
////        owner = _dictionary[cFullName] as? String
////
////    }
////
////}
////
////
////                //MARK: Create Item
////
////func itemDictionaryFrom(item: Item) -> NSDictionary {
////    return NSDictionary(objects: [item.id, item.brandId, item.categoryId, item.itemName, item.description, item.price, item.imageLinks, item.userId, item.owner, item.phoneNumber], forKeys: [cObjectId as NSCopying, cBrandId as NSCopying, cCategoryId as NSCopying, cItemName as NSCopying,cDesctiption as NSCopying, cPrice as NSCopying, cImageLinks as NSCopying, cUserForItemId as NSCopying, cFullName as NSCopying, cPhoneNumber as NSCopying])
////}
////
////
////
////            //MARK: Save item
////
////
////func SaveItem(mitem: Item){
////    FirebaseReference(.Items).document(mitem.id).setData(itemDictionaryFrom(item: mitem) as! [String : Any]) { (error) in
////
////        if error != nil {
////            print("error saving Item\(error?.localizedDescription)")
////        }
////
////    }
////}
////
//////func SaveItem(_ item: Item){
//////    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
//////}
////
////
////
////            //MARK: Download Item
////
////func downloadItemsFromDatabase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
////
////    var itemArray: [Item] = []
////
////    FirebaseReference(.Items).whereField(cCategoryId, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
////        guard let snapshot = snapshot else {
////            completion(itemArray)
////            return
////        }
////
////        if !snapshot.isEmpty {
////            for itemDict in snapshot.documents {
////                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
////            }
////        }
////
////        completion (itemArray)
////    }
////
////}
////
////
////
//////MARK: download items with ids for Cart
////
////func downloadItemsWithIds(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
////
////    var count = 0
////    var itemArray : [Item] = []
////
////    if withIds.count > 0 {
////
////        for itemId in withIds {
////            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
////                guard let snapshot = snapshot else {
////                    completion(itemArray)
////                    return
////                }
////
////                if snapshot.exists {
////                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
////                    count += 1
////                } else {
////                    completion(itemArray)
////                }
////                if count == withIds.count {
////                    completion(itemArray)
////                }
////            }
////        }
////
////    } else {
////        completion(itemArray)
////    }
////
////}
////
//////MARK: Angolia
////
////func saveItemToAngolia(item: Item) {
////    let index = AlgoliaService.shared.index
////
////    let itemToSave = itemDictionaryFrom(item: item) as! [String: Any]
////
////    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
////
////        if error != nil {
////            print("error saving to alngolia", error!.localizedDescription)
////        } else {
////            print("added to algolia")
////        }
////    }
////}
////
////
//////Searching
////func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void ) {
////
////    let index = AlgoliaService.shared.index
////    var resultIds: [String] = []
////
////    let query = Query(query: searchString)
////
////    query.attributesToRetrieve = ["itemName", "description"]
////
////    index.search(query) { (content, error) in
////
////        if error == nil {
////            let cont = content!["hits"] as! [[String: Any]]
////
////            resultIds = []
////
////            for result in cont {
////                resultIds.append(result["objectID"] as! String)
////            }
////
////            completion(resultIds)
////        }
////        else {
////            print("Error while finding the Item", error!.localizedDescription)
////            completion(resultIds)
////        }
////    }
////
////}
////
////
////
//////Update Item
////func  saveItemLocally(ItemDictionary: NSDictionary) {
////    UserDefaults.standard.set(ItemDictionary, forKey: cUserForItemId)
////    UserDefaults.standard.synchronize()
////}
////
////
////
////func updateUserItemFromDatabase(withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void){
////
////    if let dictionary = UserDefaults.standard.object(forKey: cCurrentUser){
////        let itemObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
////
////        itemObject.setValuesForKeys(withValues)
////        FirebaseReference(.Items).document()
////    }
////}
////
////
