//
//  NumberFormatterExtensions.swift
//  Camera Slider
//
//  Created by Andrew Chang on 10/30/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public static func numberFormatter(maxDecimalPlaces: Int = 0, minDecimalPlaces: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.maximumFractionDigits = maxDecimalPlaces
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        
        return formatter
    }
}
