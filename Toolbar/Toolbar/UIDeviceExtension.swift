//
//  UIDeviceExtension.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit

extension UIDevice {
    static func isLandscape() -> Bool {
        return UIDevice.current.orientation == .landscapeLeft
    }

    static func visualLandscape() -> Bool {
        if !UIDevice.isSupportedOrientation() { return false }
        return isLandscape() || UIScreen.main.bounds.height < UIScreen.main.bounds.width
    }

    static func isSupportedOrientation() -> Bool {
        let orientation = UIDevice.current.orientation
        let orientationSet: [UIDeviceOrientation] = [.landscapeLeft, .portrait, .faceUp]
        return orientationSet.contains(orientation)
    }
}


