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
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    private let numberFormatter = NumberFormatter.numberFormatter()
    private let numberFormatterWithDecimals = NumberFormatter.numberFormatter(maxDecimalPlaces: 2, minDecimalPlaces: 0)

    var rangeSlider = RangeSlider()
    var timeSlider = ColorUISlider(color: UIColor(red: 165/255, green: 0, blue: 0, alpha: 1), value: .constant(0.5))
    @State var confirmedStart: String = "--"
    @State var confirmedEnd: String = "--"
    @State var confirmedTime: String = "--"
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 500, height: 220)
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                Rectangle()
                    .foregroundColor(Color.white)
            }
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    Text("Camera Slider")
                    .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    .font(.custom("Montserrat-Bold", size: 45))
                        .padding(.leading, 20)
                    Image("camera_logo")
                    .resizable()
                        .frame(width: 120, height: 90)
                        .offset(x: -20)
                        .opacity(0.5)
                }
                
                HStack(spacing: 20){
                    VStack(spacing: 20) {
                        Text("Start")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedStart)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    
                    VStack(spacing: 20) {
                        Text("End")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedEnd)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                    .shadow(radius: 10)
                    .cornerRadius(20)
                    
    
                    VStack(spacing: 20) {
                        Text("Time")
                        .font(.custom("Montserrat-Bold", size: 20))
                        Text(confirmedTime)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                    
                }
                .frame(width: 350, height: 130, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color4"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .shadow(radius: 10)
                
                VStack(spacing: 30) {
                    rangeSlider
                        .offset(y:10)
                    VStack(spacing: 0) {
                    timeSlider
                        .padding()
                    Text("\(numberFormatter.string(from: data.time as NSNumber) ?? "") seconds")
                        .font(.custom("Montserrat-Bold", size: 12))
                    }
                    HStack{
                        Button(action: {
                            if self.bleConnection.connected == false {
                                self.showAlert = true
                            } else{
                                self.confirmedStart = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMinValue as NSNumber) ?? "")"
                                self.confirmedEnd = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMaxValue as NSNumber) ?? "")"
                                self.confirmedTime = "\(self.numberFormatter.string(from: self.data.time as NSNumber) ?? "")"
                                self.data.updateData()
                                print(self.data.bufferArray)
                                self.bleConnection.writeData(data: self.data.bufferArray)
                            }
                        }) {
                            Text("Set Data")
                                .fontWeight(.semibold)
                                .font(.custom("Montserrat-Light", size: 17))
                        }
                        .padding(18)
                        .foregroundColor(.black)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .offset(y: -10)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Bluetooth Not Connected"), message: Text("Connect to the camera slider via Bluetooth using the connect button before setting data"), dismissButton: .default(Text("Got it!")))
                        }
                        
                        Spacer()
                            .frame(width: 30)
                        
                        Button(action: {
                            if self.bleConnection.connected == false {
                            self.bleConnection.startCentralManager()
                            
                            } else {
                                print("this should not print")
                                self.bleConnection.disconnect()
                            }
                        }) {
                            HStack(spacing: 0) {
                                Text(self.bleConnection.bluetoothText)
                                        .fontWeight(.semibold)
                                        .font(.custom("Montserrat-Light", size: 17))
                                        
                                Image("bluetooth")
                                .resizable()
                                .frame(width: 25, height: 25)
                                    .offset(x: 3)
                                }
                                .aspectRatio(6, contentMode: .fill)
                                .padding()
                                .foregroundColor(.black)
                                .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(20)
                                .offset(y: -10)
                                
                            }
                        VStack{
                            Circle()
                                .fill(Color("\(self.bleConnection.greenIndicator)"))
                                .frame(width: 15, height: 15, alignment: .center)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            Circle()
                                .fill(Color("\(self.bleConnection.redIndicator)"))
                                .frame(width: 15, height: 15, alignment: .center)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        }
                        .offset(y: -10)
                            
                    }
                    
                }
                .frame(width: 360, height: 260, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color4"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .shadow(radius: 10)
                
                
                
                // ForEach: Loop here to list all BLE Devices in "devices" array
                // Monitor "devices" array for changes. As changes happen, Render the Body again.
                Button(action: {
                    if self.bleConnection.bluetoothText == "Connect" {
                        self.showAlert = true
                    }
                    else if self.confirmedStart == "--" || self.confirmedEnd == "--" || self.confirmedTime == "--" {
                        self.showAlert2 = true
                    } else {
                        self.data.prepareExecute(value: "01")
                        self.bleConnection.startCamera(data: self.data.bufferArray[3])
                    }
                }) {
                    Text("Start Camera")
                        .fontWeight(.semibold)
                        .font(.custom("Montserrat-Light", size: 30))
                }
                
                .frame(width: 350, height: 60, alignment: .center)
                .foregroundColor(.black)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .offset(y: 0)
                .shadow(radius: 10)
                .alert(isPresented: $showAlert) {
                Alert(title: Text("Bluetooth Not Connected"), message: Text("Connect to the camera slider via Bluetooth using the connect button before starting camera"), dismissButton: .default(Text("Got it!")))
                }
                .alert(isPresented: $showAlert2) {
                Alert(title: Text("Data Not Set"), message: Text("Finish setting data for start, end and time before starting the camera slider"), dismissButton: .default(Text("Got it!")))
                }
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
        Group {
        ContentView().environmentObject(DataObject())
        ContentView().environmentObject(DataObject())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
        ContentView().environmentObject(DataObject())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
            .previewDisplayName("iPhone 11 Pro")
        }
    }
    
}
#endif


