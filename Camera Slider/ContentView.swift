//
//  ContentView.swift
//  Camera Slider
//
//  Created by Andrew Chang on 10/23/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth
import UIKit


struct ContentView: View {
    @ObservedObject var bleConnection = BLEConnection()
    @EnvironmentObject var data: DataObject
    private let numberFormatter = NumberFormatter.numberFormatter()
    private let numberFormatterWithDecimals = NumberFormatter.numberFormatter(maxDecimalPlaces: 2, minDecimalPlaces: 0)

    var rangeSlider = RangeSlider()
    var timeSlider = ColorUISlider(color: UIColor(red: 165/255, green: 0, blue: 0, alpha: 1), value: .constant(0.5))
    @State var confirmedStart: String = "--"
    @State var confirmedEnd: String = "--"
    @State var confirmedTime: String = "--"
    var body: some View {
        ZStack{
            VStack() {
                Rectangle()
                    .frame(width: 500, height: 210)
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color2"), Color("color1")]), startPoint: .leading, endPoint: .trailing))
                Rectangle()
                    .foregroundColor(Color.white)
            }
            VStack(spacing: 30) {
                HStack(spacing: 50) {
                    Text("Camera Slider")
                    .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    .font(.custom("Montserrat-Bold", size: 45))
                        .padding(.leading, 20)
                    Image("camera_logo")
                    .resizable()
                        .frame(width: 130, height: 100)
                        .offset(x: -20)
                }
                
                HStack(spacing: 20){
                    VStack(spacing: 20) {
                        Text("Start")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedStart)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                    .cornerRadius(20)
                    
                    
                    VStack(spacing: 20) {
                        Text("End")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedEnd)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                    .cornerRadius(20)
    
                    VStack(spacing: 20) {
                        Text("Time")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedTime)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                    .cornerRadius(20)
                
                    
                }
                .frame(width: 350, height: 130, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color4"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                
                VStack(spacing: 30) {
                    rangeSlider
                        .offset(y:10)
                    VStack{
                    timeSlider
                        .padding()
                    Text("\(numberFormatter.string(from: data.time as NSNumber) ?? "") seconds")
                    }
                    HStack{
                        Button(action: {
                            self.confirmedStart = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMinValue as NSNumber) ?? "")"
                            self.confirmedEnd = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMaxValue as NSNumber) ?? "")"
                            self.confirmedTime = "\(self.numberFormatter.string(from: self.data.time as NSNumber) ?? "")"
                            self.data.updateData()
                            print(self.data.bufferArray)
                            self.bleConnection.writeData(data: self.data.bufferArray)
                        }) {
                            Text("Set dataification")
                                .fontWeight(.semibold)
                                .font(.custom("Montserrat-Light", size: 17))
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                        .cornerRadius(20)
                        .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                        )
                        .offset(y: -10)
                        
                        Button(action: {
                            self.bleConnection.startCentralManager()
                        }) {
                            Text("Connect")
                                    .fontWeight(.semibold)
                                    .font(.custom("Montserrat-Light", size: 17))
                            }
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                            .cornerRadius(20)
                            .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                            )
                            .offset(y: -10)
                            
                    }
                    
                }
                .frame(width: 360, height: 260, alignment: .center)
                .background(Color(red: 253/255, green: 185/255, blue: 3/255, opacity: 1))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                    )
                
                
                
                // ForEach: Loop here to list all BLE Devices in "devices" array
                // Monitor "devices" array for changes. As changes happen, Render the Body again.
                Button(action: {
                    self.data.prepareExecute(value: "01")
                    self.bleConnection.startCamera(data: self.data.bufferArray[3])
                }) {
                    Text("Start Camera")
                        .fontWeight(.semibold)
                        .font(.custom("Montserrat-Light", size: 30))
                }
                
                .frame(width: 350, height: 60, alignment: .center)
                .foregroundColor(.black)
                .background(Color(red: 165/255, green: 0, blue: 0, opacity: 1))
                .cornerRadius(20)
                .offset(y: 0)
                .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 3)
                )
                }
            }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        .background(Color(red: 36/255, green: 43/255, blue: 53/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
        }
    
        
}
    

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataObject())
    }
}
#endif


