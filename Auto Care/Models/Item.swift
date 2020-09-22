 // Item.swift
 // Auto Care

 // Created by Kilz on 04/02/2020.
 // Copyright © 2020 Kilz. All rights reserved.


import Foundation
import UIKit
import InstantSearchClient
import FirebaseAuth

class Item {
    var id: String!
    var brandId: String!
    var categoryId: String!
    var itemName: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    var userId: String!
    var owner: String!
    var phoneNumber: String!

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
        userId = _dictionary[cUserForItemId] as? String
        owner = _dictionary[cFullName] as? String
        phoneNumber = _dictionary[cPhoneNumber] as? String
    }


}


                //MARK: Create Item

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    return NSDictionary(objects: [item.id, item.brandId, item.categoryId, item.itemName, item.description, item.price, item.imageLinks, item.userId, item.owner, item.phoneNumber], forKeys: [cObjectId as NSCopying, cBrandId as NSCopying, cCategoryId as NSCopying, cItemName as NSCopying,cDesctiption as NSCopying, cPrice as NSCopying, cImageLinks as NSCopying, cUserForItemId as NSCopying, cFullName as NSCopying, cPhoneNumber as NSCopying])
}



            //MARK: Save item

func SaveItem(_ item: Item){
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}



            //MARK: Download Item


//with Category ID
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


 //func downnloadAllItems(
 func downloadAllItems(completion: @escaping (_ itemsArrary: [Item]) -> Void) {

    var itemsArrary: [Item] = []
    FirebaseReference(.Items).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion (itemsArrary)
            return
        }
        if !snapshot.isEmpty {
            for itemDictionary in snapshot.documents {
                itemsArrary.append(Item(_dictionary: itemDictionary.data() as NSDictionary))
            }
        }
        completion(itemsArrary)
    }

 }



//MARK: download items with ids for Cart

func downloadItemsWithIds(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {

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

//MARK: Angolia

func saveItemToAngolia(item: Item) {
    let index = AlgoliaService.shared.index

    let itemToSave = itemDictionaryFrom(item) as! [String: Any]

    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in

        if error != nil {
            print("error saving to alngolia", error!.localizedDescription)
        } else {
            print("added to algolia")
        }
    }
}


//Searching
func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void ) {

    let index = AlgoliaService.shared.index
    var resultIds: [String] = []

    let query = Query(query: searchString)

    query.attributesToRetrieve = ["itemName", "description"]

    index.search(query) { (content, error) in

        if error == nil {
            let cont = content!["hits"] as! [[String: Any]]

            resultIds = []

            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }

            completion(resultIds)
        }
        else {
            print("Error while finding the Item", error!.localizedDescription)
            completion(resultIds)
        }
    }

}



//Update Item
func  saveItemLocally(ItemDictionary: NSDictionary) {
    UserDefaults.standard.set(ItemDictionary, forKey: cUserForItemId)
    UserDefaults.standard.synchronize()
}

func currentUserItemID() -> String {
    return Auth.auth().currentUser!.uid
}

func currentItem() -> Item? {
    if Auth.auth().currentUser != nil {
        if let dictionary = UserDefaults.standard.object(forKey: cUserForItemId){
            return Item.init(_dictionary: dictionary as! NSDictionary)
        }
    }

    return nil
}

func updateUserItemFromDatabase(withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void){

    if let dictionary = UserDefaults.standard.object(forKey: cUserForItemId){
        let userItem = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary

        userItem.setValuesForKeys(withValues)
        FirebaseReference(.Items).document(User.currentID()).updateData(withValues) {
            (error) in
            completion(error)
            if error == nil {
                saveItemLocally(ItemDictionary: userItem)
            }
        }
    }
}
 

 //MARK: DELETE ITEM
 func deleteItemFromDB(_ itemId: Item){

    FirebaseReference(.Items).document(itemId.id).delete()
    
 }


