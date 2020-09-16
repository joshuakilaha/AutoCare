//
//  Brand.swift
//  Auto Care
//  Created by Kilz on 28/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import UIKit

class Brand {
    
    var id: String!
    var brandName: String!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cObjectId] as? String
        brandName = _dictionary[cBrandName] as? String
        imageLinks = _dictionary[cImageLinks] as? [String]
    }
    
}


        //MARK: Create Brand

func brandDictionaryFrom(_ brand: Brand) -> NSDictionary {
    return NSDictionary(objects: [brand.id!, brand.brandName!, brand.imageLinks!], forKeys: [cObjectId as NSCopying, cBrandName as NSCopying, cImageLinks as NSCopying])
    
}


        //MARK: Save brand

func saveBrand(_ brand: Brand){
    let id = UUID().uuidString
    brand.id = id
    FirebaseReference(.Brand).document(brand.id).setData(brandDictionaryFrom(brand) as! [String: Any])
}


        //MARK: Download Brand

func downloadBrandFromDatabase(completion: @escaping (_ brandArray: [Brand]) -> Void){
    
    var brandArray: [Brand] = []
    FirebaseReference(.Brand).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion (brandArray)
            return
        }
        if !snapshot.isEmpty {
            for brandDictionary in snapshot.documents {
                brandArray.append(Brand(_dictionary: brandDictionary.data() as NSDictionary))
            }
        }
        
        completion(brandArray)
    }
    
}



//MARK: BRAND IMGAGE UPLOAD

//Algolia Saving Brand

//func saveItemToAngolia(item: Item) {
//    let index = AlgoliaService.shared.index
//
//    let itemToSave = itemDictionaryFrom(item) as! [String: Any]
//
//    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
//
//        if error != nil {
//            print("error saving to alngolia", error!.localizedDescription)
//        } else {
//            print("added to algolia")
//        }
//    }
//}

