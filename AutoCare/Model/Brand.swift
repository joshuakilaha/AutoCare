//
//  Brand.swift
//  AutoCare
//
//  Created by Kilz on 15/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import Foundation
import UIKit

class Brand {
    
    var id: String
      var name: String
      var image: UIImage?
      var imageName: String?
      
      init(_name : String, _imageName: String) {
          id = ""
          name = _name
          imageName = _imageName
          image = UIImage(named: _imageName)
          
      }
    
    init(_dictionary: NSDictionary) {
          
          id = _dictionary[cObjectID] as! String
          name = _dictionary[cName] as! String
          image = UIImage(named:_dictionary[cImageName] as? String ?? "")
      }
    
}
    


    
    
        //creating Brand

/*
    func createBrandSet() {
        let Toyota = Brand(_name: "Toyota", _imageName: "toyota")
            let Mercedes_Benz = Brand(_name: "Mercedes Benz ", _imageName: "mercedes-benz")
            let Bmw = Brand(_name: "Bmw", _imageName: "bmw")
            let LandRover = Brand(_name: "LandRover", _imageName: "landrover")
            let Honda = Brand(_name: "Honda", _imageName: "honda")
            let Jeep = Brand(_name: "Jeep", _imageName: "jeep")
            let Alfa_Romeo = Brand(_name: "Alfa Romeo", _imageName: "alfa-romeo")
            let Volkswagen = Brand(_name: "Volkswagen", _imageName: "volkswagen")
            let Audi = Brand(_name: "Audi", _imageName: "audi")
            let Mazda = Brand(_name: "Mazda", _imageName: "mazda")
            let Nissan = Brand(_name: "Nissan", _imageName: "nissan")
            let Subaru = Brand(_name: "Subaru", _imageName: "subaru")
            let Mitsubishi = Brand(_name: "Mitsubishi", _imageName: "mitsubishi")
            let Suzuki = Brand(_name: "Suzuki", _imageName: "suzuki")
            let Lexus = Brand(_name: "Lexus", _imageName: "lexus")
        
        
            let arrayOfBrands = [Toyota,Mercedes_Benz,Bmw,LandRover,Honda,Jeep,Alfa_Romeo,Volkswagen,Audi,
                                     Mazda,Nissan,Subaru,Mitsubishi,Suzuki,Lexus]
        
            for brands in arrayOfBrands {
                saveBrandToFirebase(brands)
            }
    }
    
    */


    
        //save Brand to Database
    func saveBrandToFirebase(_ brand: Brand) {
        let id = UUID().uuidString
        brand.id = id
        
       
        FirebaseReference(.cBRAND_PATH).document(id).setData(brandDictionaryFrom(brand)
            as! [String: Any])
        
    }


      //helpers
    func brandDictionaryFrom(_ brand: Brand) -> NSDictionary {
        
        return NSDictionary(objects: [brand.id, brand.name, brand.imageName],
                            forKeys: [cObjectID as NSCopying, cName as NSCopying, cImageName as NSCopying])
     
    }
        
        //getting Brand From Database
    func getBrandFromFirebase(completion: @escaping (_ brandArray: [Brand]) -> Void){
        var brandArray: [Brand] = []
        FirebaseReference(.cBRAND_PATH).getDocuments {(snapshot, error) in
            guard let snapshot = snapshot else {
                completion (brandArray)
                return
            }
            if !snapshot.isEmpty {
                for brandDictionary in snapshot.documents {
                    brandArray.append(Brand(_dictionary: brandDictionary.data() as NSDictionary))
                }
            }
            completion (brandArray)
        }
        
    }
    
    
  
    




