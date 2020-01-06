//
//  HelperFunctions.swift
//  AutoCare
//
//  Created by Kilz on 06/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    let currencyForMatter = NumberFormatter()
    currencyForMatter.usesGroupingSeparator = true
    currencyForMatter.numberStyle = .currency
    currencyForMatter.locale = Locale.current
    
    return currencyForMatter.string(from: NSNumber(value: number))!
    
}
