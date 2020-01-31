//
//  CurrencyConverter.swift
//  Auto Care
//
//  Created by Kilz on 28/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation

func convertCurrency(_ number: Double) -> String {
    let currencyForValue = NumberFormatter()
    currencyForValue.usesGroupingSeparator = true
    currencyForValue.numberStyle = .currency
    currencyForValue.locale = Locale.current
    
    return currencyForValue.string(from: NSNumber(value: number))!
}
