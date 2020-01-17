//
//  HelperFunctions.swift
//  AutoCare
//
//  Created by Kilz on 06/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    let currencyForValue = NumberFormatter()
    currencyForValue.usesGroupingSeparator = true
    currencyForValue.numberStyle = .currency
    currencyForValue.locale = Locale.current
    
    return currencyForValue.string(from: NSNumber(value: number))!
    
}
