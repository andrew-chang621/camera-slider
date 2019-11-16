//
//  DataObject.swift
//  Camera Slider
//
//  Created by Andrew Chang on 11/5/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//

import Foundation
import SwiftUI

open class DataObject: ObservableObject {
    let oneBuffer = Data(bytes: "01".hexa, count: 1)
    @Published var startArray: [UInt8] = []
    @Published var endArray: [UInt8] = []
    @Published var timeArray: [UInt8] = []
    @Published var executeArray: [UInt8] = []
    @Published var selectedMinValue: CGFloat = 0.00
    @Published var selectedMaxValue: CGFloat = 1.00
    @Published var time: Double = 0
    @Published var bufferArray: [Data] = []
    
    
    func updateData() {
        let startHex = String(Int(selectedMinValue * 100), radix: 16)
        let endHex = String(Int(selectedMaxValue * 100), radix: 16)
        let timeHex = makeTwoBytes(value: String(Int(round(time)), radix:16))
        startArray = startHex.hexa
        endArray = endHex.hexa
        timeArray = timeHex.hexa
        let startBuffer = Data(bytes: startArray, count: 1)
        let endBuffer = Data(bytes: endArray, count: 1)
        let timeBuffer = Data(bytes: timeArray, count: 2)
        print(startArray)
        print(endArray)
        print(timeArray)
        if bufferArray.count == 0 {
            bufferArray.append(startBuffer)
            bufferArray.append(endBuffer)
            bufferArray.append(timeBuffer)
        } else {
            bufferArray[0] = startBuffer
            bufferArray[1] = endBuffer
            bufferArray[2] = timeBuffer
        }
        
        print(startHex + " " + endHex + " " + timeHex)
    }
    
    func makeTwoBytes(value: String) -> String {
        var result = value
        while result.count < 4 {
            result = "0" + result
        }
        return result
    }
}

extension StringProtocol {
    var hexa: [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
