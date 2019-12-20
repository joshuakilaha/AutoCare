//
//  FirebaseCollectionReferences.swift
//  AutoCare
//
//  Created by Kilz on 15/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case cUSER_PATH
    case cBRAND_PATH
    case cCATEGORY_PATH
    case cITEMS_PATH
    case cCart_PATH

}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
    
}


