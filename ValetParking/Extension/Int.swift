//
//  Int.swift
//  BaseComponents
//
//  Created by Hunain Shahid on 24/10/2017.
//  Copyright © 2017 Brainx Technologies. All rights reserved.
//

import Foundation

extension Int {
    var isEven:Bool {
        return (self % 2 == 0)
    }
    
    var isOdd:Bool {
        return (self % 2 != 0)
    }
    
    var isPositive:Bool {
        return (self >= 0)
    }
    
    var isNegative:Bool {
        return (self < 0)
    }
    
    var toDouble:Double {
        return Double(self)
    }
    
    var toFloat:Float {
        return Float(self)
    }
    
    var digits: Int {
        if (self == 0) {
            return 1
        } else if(Int(fabs(Double(self))) <= LONG_MAX){
            return Int(log10(fabs(Double(self)))) + 1
        } else {
            print("Out of bounds")
            return -1;
        }
    }
}
