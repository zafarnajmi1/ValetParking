//
//  Double.swift
//  Buoy
//
//  Created by Thanh-Tam Le on 7/31/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

extension Double {

    func formatAsCurrency(currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits =  100
        return currencyFormatter.string(from: NSNumber(value: self))
    }
    
    func roundedTo(decimals: Int) -> Double {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.multiplier = 1
        format.roundingMode = .up
        format.maximumFractionDigits = decimals
        format.number(from: format.string(for: self )! )
        
        return (format.number(from: format.string(for: self )! )) as! Double
    }
}
