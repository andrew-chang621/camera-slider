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
    @State var showAlert3: Bool = false
    @State var showAlert4: Bool = false
    @State var rebootAlert: Bool = true
    @State var expand = false
    @State var xExpand = 100
    @State var yExpand = -250
    private let numberFormatter = NumberFormatter.numberFormatter()
    private let numberFormatterWithDecimals = NumberFormatter.numberFormatter(maxDecimalPlaces: 2, minDecimalPlaces: 0)
    var rangeSlider = RangeSlider()
    var timeSlider = ColorUISlider(color: UIColor(red: 165/255, green: 0, blue: 0, alpha: 1), value: .constant(0.5), maxVal: .constant(500), minVal: .constant(1))
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
                    Text("Camera Slider")
                    .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    .font(.custom("Montserrat-Bold", size: 50))
                        .offset(y: 10)
                    .frame(width: 300, height: 130, alignment: .leading)
                    .offset(x: -10)
                
                HStack(spacing: 20){
                    VStack(spacing: 20) {
                        Text("Start")
                        .font(.custom("Montserrat-Bold", size: 30))
                        Text(confirmedStart)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    
                    VStack(spacing: 20) {
                        Text("End")
                        .font(.custom("Montserrat-Bold", size: 30))
                        Text(confirmedEnd)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
                    .shadow(radius: 10)
                    .cornerRadius(20)
                    
    
                    VStack(spacing: 20) {
                        Text("Time")
                        .font(.custom("Montserrat-Bold", size: 30))
                        Text(confirmedTime)
                        .font(.custom("Montserrat-Bold", size: 20))
                    }
                    .frame(width: 90, height: 100)
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
                    
                    Button(action: {
                        if self.bleConnection.connected == false {
                            self.showAlert = true
                        } else{
                            self.confirmedStart = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMinValue as NSNumber) ?? "") m"
                            self.confirmedEnd = "\(self.numberFormatterWithDecimals.string(from: self.data.selectedMaxValue as NSNumber) ?? "") m"
                            self.confirmedTime = "\(self.numberFormatter.string(from: self.data.time as NSNumber) ?? "") s"
                            self.data.updateData()
                            print(self.data.bufferArray)
                            self.bleConnection.writeData(data: self.data.bufferArray)
                        }
                    }) {
                        Text("Set Specificaitons")
                            .fontWeight(.semibold)
                            .font(.custom("Montserrat-Light", size: 17))
                    }
                    .frame(width: 180, height: 40)
                    .foregroundColor(.black)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    .offset(y: -10)
                    .buttonStyle(buttonAnimationStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Bluetooth Not Connected"), message: Text("Connect to the camera slider via Bluetooth using the connect button before setting data"), dismissButton: .default(Text("Got it!")))
                    }
                        
                    
                }
                .frame(width: 350, height: 260, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color4"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .shadow(radius: 10)
                
                
                
                // ForEach: Loop here to list all BLE Devices in "devices" array
                // Monitor "devices" array for changes. As changes happen, Render the Body again.
                Button(action: {
                    if self.bleConnection.bluetoothText == "Connect" {
                        self.showAlert = true
                    }
                    if self.confirmedStart == "--" || self.confirmedEnd == "--" || self.confirmedTime == "--" {
                        self.showAlert2 = true
                        self.showAlert = false
                        print("yes")
                    } else {
                        self.bleConnection.startCamera(data: self.data.oneBuffer)
                    }
                }) {
                    Text("Start Camera")
                        .fontWeight(.semibold)
                        .font(.custom("Montserrat-Light", size: 30))
                }
                .buttonStyle(buttonAnimationStyle())
                .frame(width: 350, height: 70, alignment: .center)
                .foregroundColor(.black)
                .background(LinearGradient(gradient: Gradient(colors: [Color("color6"), Color("color5")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .offset(y: 0)
                .shadow(radius: 10)
                .alert(isPresented: $showAlert) {
                Alert(title: Text("Bluetooth Not Connected"), message: Text("Connect to the camera slider via Bluetooth using the connect button before starting camera"), dismissButton: .default(Text("Got it!")))
                }
                .alert(isPresented: $showAlert2) {
                Alert(title: Text("Data Not Set"), message: Text("Finish setting data for start, end, and time before starting the camera slider"), dismissButton: .default(Text("Got it!")))
                }
            }
            VStack(spacing: 20) {
                HStack {
                Image("raspberrypi")
                   .resizable()
                   .frame(width: 55, height: 70)
                   .onTapGesture { self.expand.toggle() }
                   .padding()
                VStack{
                    Circle()
                        .fill(Color("\(self.bleConnection.greenIndicator)"))
                        .frame(width: 15, height: 15, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    Circle()
                        .fill(Color("\(self.bleConnection.redIndicator)"))
                        .frame(width: 15, height: 15, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                } .offset(x: -15)
                }
               if expand {
                   Button(action: {
                       if self.bleConnection.connected == false {
                       self.bleConnection.startCentralManager()
                           print(self.bleConnection.bluetoothText)
                       
                       } else {
                           self.bleConnection.disconnect()
                       }
                   }) {
                       Text(self.bleConnection.bluetoothText)
                           .font(.custom("Montserrat-Bold", size: 15))
                   }.offset(y: -20)
                    .buttonStyle(buttonAnimationStyle())
                .foregroundColor(Color.black)
                   Button(action: {
                    if self.bleConnection.connected == false {
                        self.showAlert3 = true
                        self.rebootAlert = false
                    } else {
                       self.bleConnection.reboot(data: self.data.oneBuffer)
                        self.rebootAlert = true
                        self.showAlert3 = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                            self.bleConnection.startCentralManager()
                        }
                        }
                   }) {
                       Text("Reboot")
                        .font(.custom("Montserrat-Bold", size: 15))
                   } .offset(y: -20)
                    .foregroundColor(Color.black)
                    .buttonStyle(buttonAnimationStyle())
                    .alert(isPresented: $rebootAlert) {
                        Alert(title: Text("Reboot Starting"), message: Text("Please wait 40 seconds for the Raspberry Pi to reboot and reconnect"), dismissButton: .default(Text("Got it!")))
                    }
                   .alert(isPresented: $showAlert3) {
                    Alert(title: Text("Bluetooth Not Connected"), message: Text("Must be connected to Raspberry Pi via bluetooth to reboot"), dismissButton: .default(Text("Got it!")))
                }
                   Button(action: {
                    if self.bleConnection.connected == false {
                        self.showAlert4 = true
                    } else {
                        self.bleConnection.shutdown(data: self.data.oneBuffer)
                        self.showAlert4 = false
                    }
                   }) {
                       Text("Shutdown")
                        .font(.custom("Montserrat-Bold", size: 15))
                   }.offset(y: -20)
                .foregroundColor(Color.black)
                .buttonStyle(buttonAnimationStyle())
                .alert(isPresented: $showAlert4) {
                    Alert(title: Text("Bluetooth Not Connected"), message: Text("Must be connected to Raspberry Pi via bluetooth to shut down"), dismissButton: .default(Text("Got it!")))
                }
               }
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("color4"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke(Color.black, lineWidth: 3))
            .offset(x: 120, y: self.expand ? -193 : -250)
            .animation(.spring())
            
        }

        .edgesIgnoringSafeArea(.all)
        }
    
        
}

struct buttonAnimationStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View { configuration.label
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(DataObject())
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
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


