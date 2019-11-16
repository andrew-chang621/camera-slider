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
    @State var start : CGFloat = 0.00
    @State var end : CGFloat = 1.00
    private let numberFormatter = NumberFormatter.numberFormatter(maxDecimalPlaces: 2, minDecimalPlaces: 2)
    let minValue : CGFloat = 0
    let maxValue : CGFloat = 1.00
    let step : CGFloat = 0.01
    private let lineWidth: CGFloat = 270.0
    private let handleDiameter: CGFloat = 24
    
    var body: some View {
            let leftHandleDragGesture = DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    guard value.location.x >= 0, value.location.x <= (self.lineWidth + self.handleDiameter) else {
                        return
                    }
                    self.leftHandleViewState.width = value.location.x
                    let percentage = self.leftHandleViewState.width/(self.lineWidth + self.handleDiameter)
                    self.data.selectedMinValue = max(percentage * (self.maxValue - self.minValue) + self.minValue, self.minValue)
                    self.data.selectedMinValue = CGFloat(roundf(Float(self.data.selectedMinValue / self.step))) * self.step
            }
            let rightHandleDragGesture = DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    guard value.location.x <= 0, value.location.x >= -(self.lineWidth + self.handleDiameter) else {
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
                        Text("\(numberFormatter.string(from: data.selectedMinValue as NSNumber) ?? "")")
                        .font(.custom("Montserrat-Bold", size: 12))
                            .offset(y: 5)
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: 30, height: 30, alignment: .center)
                            Text("S")
                            .font(.custom("Montserrat-Bold", size: 20))
                        }
                        
                    } .zIndex(1) .offset(x: leftHandleViewState.width + 5, y: -13)
                    .gesture(leftHandleDragGesture)
                    Rectangle()
                        .frame(width: lineWidth, height: CGFloat(3.0), alignment: .center)
                        .zIndex(0)
                    VStack{
                        ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 30, height: 30, alignment: .center)
                            Text("E")
                            .font(.custom("Montserrat-Bold", size: 20))
                        }
                        Text("\(numberFormatter.string(from: data.selectedMaxValue as NSNumber) ?? "")")
                        .font(.custom("Montserrat-Bold", size: 12))
                    } .zIndex(1) .offset(x: rightHandleViewState.width - 5, y: 10)
                        .gesture(rightHandleDragGesture)
                    }
        
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        RangeSlider().environmentObject(DataObject())
    }
}

