//
//  FirebaseCollectionReferences.swift
//  AutoCare
//
//  Created by Kilz on 05/12/2019.
//  Copyright © 2019 joshua kilaha. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference : String {
    case User
    case Category
    case Items
    case Cart
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
