//
//  RangeSlider.swift
//  Camera Slider
//
//  Created by Andrew Chang on 10/23/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//

import SwiftUI

struct RangeSlider: View {
    @EnvironmentObject var data: DataObject
    @State var leftHandleViewState = CGSize.zero
    @State var rightHandleViewState = CGSize.zero
    @State var start : CGFloat = 0
    @State var end : CGFloat = 1.35
    private let numberFormatter = NumberFormatter.numberFormatter(maxDecimalPlaces: 2, minDecimalPlaces: 0)
    let minValue : CGFloat = 0.15
    let maxValue : CGFloat = 1.35
    let step : CGFloat = 0.01
    private let lineWidth: CGFloat = 300.0
    private let handleDiameter: CGFloat = 30
    
    var body: some View {
            let leftHandleDragGesture = DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    guard value.location.x >= 0 && value.location.x <= 300 else {
                        return
                    }
                    self.leftHandleViewState.width = value.location.x
                    let percentage = self.leftHandleViewState.width/(self.lineWidth + self.handleDiameter)
                    self.data.selectedMinValue = max(percentage * (self.maxValue - self.minValue) + self.minValue, self.minValue)
                    self.data.selectedMinValue = CGFloat(roundf(Float(self.data.selectedMinValue / self.step))) * self.step
            }
            let rightHandleDragGesture = DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    guard value.location.x <= 0 && value.location.x >= -300 else {
                        return
                    }
                    self.rightHandleViewState.width = value.location.x
                    let percentage = 1 - abs(self.rightHandleViewState.width)/(self.lineWidth + self.handleDiameter)
                    self.data.selectedMaxValue = max(percentage * (self.maxValue - self.minValue) + self.minValue, self.minValue)
                    self.data.selectedMaxValue = CGFloat(roundf(Float(self.data.selectedMaxValue / self.step))) * self.step
            }
            return
                    HStack(spacing: 0) {
                    VStack {
                        ZStack {
                        Circle()
                            .fill(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                            .frame(width: 30, height: 30, alignment: .center)
                            Text("S")
                            .font(.custom("Montserrat-Bold", size: 20))
                        }
                        Text("\(numberFormatter.string(from: data.selectedMinValue as NSNumber) ?? "")")
                        .font(.custom("Montserrat-Bold", size: 12))
                    } .zIndex(1) .offset(x: leftHandleViewState.width + 15, y: 15)
                    .gesture(leftHandleDragGesture)
                    Rectangle()
                        .frame(width: CGFloat(300.0), height: CGFloat(3.0), alignment: .center)
                        .zIndex(0)
                    VStack{
                        ZStack {
                        Circle()
                            .fill(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                            .frame(width: 30, height: 30, alignment: .center)
                            Text("E")
                            .font(.custom("Montserrat-Bold", size: 20))
                        }
                        Text("\(numberFormatter.string(from: data.selectedMaxValue as NSNumber) ?? "")")
                        .font(.custom("Montserrat-Bold", size: 12))
                    } .zIndex(1) .offset(x: rightHandleViewState.width - 15, y: 15)
                        .gesture(rightHandleDragGesture)
                    }
        
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        RangeSlider().environmentObject(DataObject())
    }
}

