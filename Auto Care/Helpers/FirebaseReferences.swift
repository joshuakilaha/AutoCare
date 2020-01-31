//
//  FirebaseReferences.swift
//  Auto Care
//
//  Created by Kilz on 28/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FirebaseCollectionReference: String {
    case User
    case Brand
    case Category
    case Items
    case Cart
    
}

func FirebaseReference(_ collectionRefernce: FirebaseCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRefernce.rawValue)
}
