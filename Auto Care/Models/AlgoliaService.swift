//
//  AgoliaService.swift
//  Auto Care
//
//  Created by Kilz on 07/03/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    static let shared = AlgoliaService()
    
    let client = Client(appID: cAngolia_APP_ID, apiKey: cAngolia_Admin_Key)
    let index = Client(appID: cAngolia_APP_ID, apiKey: cAngolia_Admin_Key).index(withName: "item_Name")
    
    private init() {}
}
