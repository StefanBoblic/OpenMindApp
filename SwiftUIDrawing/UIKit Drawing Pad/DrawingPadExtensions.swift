//
//  DrawingPadExtensions.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import UIKit

extension UIImage {
    func getColor(at location: CGPoint) -> UIColor? {
        guard let cgImage = cgImage,
              let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data
        else { return nil }

        let scale = UIScreen.main.scale
        let pixelLocation = CGPoint(x: location.x * scale, y: location.y * scale)

        let pixel = cgImage.bytesPerRow * Int(pixelLocation.y) + cgImage.bitsPerPixel / 8 * Int(pixelLocation.x)
        guard pixel < CFDataGetLength(pixelData) else {
            print("Warning: mismatch of pixel data")
            return nil
        }

        guard let pointer = CFDataGetBytePtr(pixelData) else { return nil }

        func convert(_ color: UInt8) -> CGFloat {
            CGFloat(color) / 255.0
        }

        let red = convert(pointer[pixel])
        let green = convert(pointer[pixel + 1])
        let blue = convert(pointer[pixel + 2])
        let alpha = convert(pointer[pixel + 3])

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
