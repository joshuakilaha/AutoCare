//
//  Category.swift
//  Auto Care
//
//  Created by Kilz on 31/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation

class Category {
    
   var id: String!
    var brandId: String! 
    var categoryName: String!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cObjectId] as? String
        brandId = _dictionary[cBrandId] as? String
        categoryName = _dictionary[cCategoryName] as? String
        imageLinks = _dictionary[cImageLinks] as? [String]
    }
}


//MARK: Create Category
func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.brandId, category.categoryName, category.imageLinks], forKeys: [cObjectId as NSCopying, cBrandId as NSCopying, cCategoryName as NSCopying, cImageLinks as NSCopying])
    
}


//MARK: Save Category

func saveCategory(_ category: Category) {
    FirebaseReference(.Category).document(category.id).setData(categoryDictionaryFrom(category) as! [String: Any])
}


//MARK: Download Category

func downloadCategoryFromDatabase(_ withBrandid: String, completion: @escaping (_ categoryArray: [Category]) -> Void){
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).whereField(cBrandId, isEqualTo: withBrandid).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty {
            for categoryDictionary in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDictionary.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
    
}
