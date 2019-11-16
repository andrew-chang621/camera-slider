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
    @State var maxVal: Float = 500
    @State var minVal: Float = 1

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

    func makeUIView(context: UIViewRepresentableContext<ColorUISlider>) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = color
        slider.tintColor = .black
        slider.value = Float(value)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        slider.maximumValue = 500
        slider.minimumValue = 1
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<ColorUISlider>) {
        uiView.value = Float(value)
        print("updating UI")
        uiView.maximumValue = 500
        uiView.minimumValue = 1
    }
}

struct ColorUISlider_Previews: PreviewProvider {
    static var previews: some View {
        ColorUISlider(color: .red, value: .constant(0.5)).environmentObject(DataObject())
    }
}
