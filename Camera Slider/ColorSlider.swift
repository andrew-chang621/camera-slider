//
//  ColorSlider.swift
//  Camera Slider
//
//  Created by Andrew Chang on 11/4/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//
import UIKit
import SwiftUI

struct ColorUISlider: UIViewRepresentable {
    var color: UIColor
    @Binding var value: Double
    @EnvironmentObject var data: DataObject
    @Binding var maxVal: Float
    @Binding var minVal: Float
    
    class Coordinator: NSObject {
        let parent:ColorUISlider
        init(parent:ColorUISlider) {
            self.parent = parent
        }
    
        @objc func valueChanged(_ sender: UISlider) {
            self.parent.data.time = Double(sender.value)
        }
    }

    func makeCoordinator() -> ColorUISlider.Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        maxVal = Float(data.selectedMaxValue * 500)
        minVal = Float(data.selectedMinValue * 4)
        slider.thumbTintColor = color
        slider.tintColor = .black
        slider.value = Float(value)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        slider.maximumValue = 500
        slider.minimumValue = 1
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
        print("updating UI")
        uiView.maximumValue = maxVal
        uiView.minimumValue = minVal
    }
}

struct ColorUISlider_Previews: PreviewProvider {
    static var previews: some View {
        ColorUISlider(color: .red, value: .constant(0.5), maxVal: .constant(500), minVal: .constant(4))
    }
}
