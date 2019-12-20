//
//  Category.swift
//  AutoCare
//
//  Created by Kilz on 15/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var brandId: String!
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_brandId: String, _name : String, _imageName: String) {
        id = ""
        brandId = _brandId
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
        
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[cObjectID] as! String
        brandId = _dictionary[cBrandID] as? String
        name = _dictionary[cName] as! String
        image = UIImage(named:_dictionary[cImageName] as? String ?? "")
        
    }
    
}

//Retriving Items from Database
func getCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void){
    
    var categoryArray: [Category] = []
    FirebaseReference(.cCATEGORY_PATH).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            for categoryDictionay in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDictionay.data() as NSDictionary))
            }
        }
        completion(categoryArray)
    }
    
}



/// saving category function to firebase
func saveCategoryToFirebase(_ category: Category){
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.cCATEGORY_PATH).document(id).setData(categoryDictionaryFrom(category)
        as! [String: Any])
    
}


//helpers
func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.brandId ,category.name, category.imageName],
                        forKeys: [cObjectID as NSCopying, cBrandID as NSCopying, cName as NSCopying, cImageName as NSCopying])
    
}


        //creatingCategorySet one time
//func createCategorySet(){
//    let Toyota = Category(_name: "Tires", _imageName: "toyota")
//    let Mercedes_Benz = Category(_name: "Mercedes Benz ", _imageName: "Mercedes-Benz")
//    let Bmw = Category(_name: "Bmw", _imageName: "Bmw")
//    let LandRover = Category(_name: "LandRover", _imageName: "LandRover")
//    let Honda = Category(_name: "Honda", _imageName: "Honda")
//    let Jeep = Category(_name: "Jeep", _imageName: "Jeep")
//    let Alfa_Romeo = Category(_name: "Alfa Romeo", _imageName: "Alfa-Romeo")
//    let Volkswagen = Category(_name: "Volkswagen", _imageName: "Volkswagen")
//    let Audi = Category(_name: "Audi", _imageName: "Audi")
//    let Mazda = Category(_name: "Mazda", _imageName: "Mazda")
//    let Nissan = Category(_name: "Nissan", _imageName: "Nissan")
//    let Subaru = Category(_name: "Subaru", _imageName: "Subaru")
//    let Mitsubishi = Category(_name: "Mitsubishi", _imageName: "Mitsubishi")
//    let Suzuki = Category(_name: "Suzuki", _imageName: "Suzuki")
//    let Lexus = Category(_name: "Lexus", _imageName: "Lexus")
//
//
//    let arrayOfCategories = [Toyota,Mercedes_Benz,Bmw,LandRover,Honda,Jeep,Alfa_Romeo,Volkswagen,Audi,
//                             Mazda,Nissan,Subaru,Mitsubishi,Suzuki,Lexus]
//
//    for category in arrayOfCategories {
//        saveCategoryToFirebase(category)
//    }
//
//}
