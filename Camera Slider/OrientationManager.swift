//
//  OrientationManager.swift
//  Camera Slider
//
//  Created by Andrew Chang on 11/10/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//

import SwiftUI

struct SupportedOrientationsPreferenceKey: PreferenceKey {
    typealias Value = UIInterfaceOrientationMask
    static var defaultValue: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .portrait
        }
        else {
            return .portrait
        }
    }
      
    static func reduce(value: inout UIInterfaceOrientationMask, nextValue: () -> UIInterfaceOrientationMask) {
        // use the most restrictive set from the stack
        value.formIntersection(nextValue())
    }
}
  

class OrientationLockedController<Content: View>: UIHostingController<OrientationLockedController.Root<Content>> {
    class Box {
        var supportedOrientations: UIInterfaceOrientationMask
        init() {
            self.supportedOrientations =
            .portrait
        }
    }
      
    var orientations: Box!
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientations.supportedOrientations
    }
      
    init(rootView: Content) {
        let box = Box()
        let orientationRoot = Root(contentView: rootView, box: box)
        super.init(rootView: orientationRoot)
        self.orientations = box
    }
      
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    struct Root<Content: View>: View {
        let contentView: Content
        let box: Box
          
        var body: some View {
            contentView
                .onPreferenceChange(SupportedOrientationsPreferenceKey.self) { value in
                    // Update the binding to set the value on the root controller.
                    self.box.supportedOrientations = value
            }
        }
    }
}
  
extension View {
    func supportedOrientations(_ supportedOrientations: UIInterfaceOrientationMask) -> some View {
        // When rendered, export the requested orientations upward to Root
        preference(key: SupportedOrientationsPreferenceKey.self, value: supportedOrientations)
    }
}

