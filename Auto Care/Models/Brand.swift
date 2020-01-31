//
//  Brand.swift
//  Auto Care
//
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


//create Brand

func brandDictionaryFrom(_ brand: Brand) -> NSDictionary {
    return NSDictionary(objects: [brand.id, brand.brandName, brand.imageLinks], forKeys: [cObjectId as NSCopying, cBrandName as NSCopying, cImageLinks as NSCopying])
    
}


//Saving brand

func saveBrand(_ brand: Brand){
    FirebaseReference(.Brand).document(brand.id).setData(brandDictionaryFrom(brand) as! [String: Any])
}


//Downloading Brand

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

