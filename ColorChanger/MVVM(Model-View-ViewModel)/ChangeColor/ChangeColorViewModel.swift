//
//  ChangeColorViewModel.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import Foundation
import UIKit

class ChangeColorViewModel: ChangeColorProtocol
{
    
    /// View Model Didload Method
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func didLoad(target:ChangeColorViewController)
    {
        target.horizontalSaturationPicker.currentColor = target.currrentColor
        target.horizontalBrightnessPicker.currentColor = target.currrentColor
        target.horizontalAlphaPicker.currentColor = target.currrentColor
        target.horizontalColorPicker.delegate = target
        target.horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        target.horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.color
        
        target.horizontalSaturationPicker.delegate = target
        target.horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        target.horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.saturation
        
        target.horizontalBrightnessPicker.delegate = target
        target.horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        target.horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.brightness
        
        target.horizontalAlphaPicker.delegate = target
        target.horizontalAlphaPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        target.horizontalAlphaPicker.type = SwiftHUEColorPicker.PickerType.alpha
        
        
        DispatchQueue.main.async {
            target.imageView.image = target.input
            
            let r = target.currrentColor.coreImageColor.red
            let g = target.currrentColor.coreImageColor.green
            let b = target.currrentColor.coreImageColor.blue
            target.rgb  = (Float(r),Float(g),Float(b))
            target.defaultHue = self.RGBtoHSV(target.rgb.0, g: target.rgb.1, b: target.rgb.2).h
            
            target.ciImage = CIImage(image: target.imageView.image!)
            
        }
    }
    
    /// Applying Color by gather RGB Points
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func applyColor(target:ChangeColorViewController)
    {
        let r = target.currrentColor.coreImageColor.red
        let g = target.currrentColor.coreImageColor.green
        let b = target.currrentColor.coreImageColor.blue
        target.rgb  = (Float(r),Float(g),Float(b))
        target.defaultHue = RGBtoHSV(target.rgb.0, g: target.rgb.1, b: target.rgb.2).h
        
        self.changeImage(target: target)
    }
    
    /// Changing Image Object Color using ColorCube
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func changeImage(target:ChangeColorViewController)
    {
        
        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0,0,0]
        var hsv: (h : Float, s : Float, v : Float) = (0,0,0)
        var newRGB: (r : Float, g : Float, b : Float)
        var offset = 0
        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {
                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(rgb[0], g: rgb[1], b: rgb[2])
                    
                    
                    hsv.h =    target.defaultHue - hsv.h
                    
                    newRGB = HSVtoRGB(hsv.h, s:hsv.s, v:hsv.v)
                    
                    cubeData[offset] = newRGB.r
                    cubeData[offset+1] = newRGB.g
                    cubeData[offset+2] = newRGB.b
                    cubeData[offset+3] = 1.0
                    offset += 4
                }
            }
        }
        
        
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as NSData
        let colorCube = CIFilter(name: "CIColorCube")!
        colorCube.setValue(size, forKey: "inputCubeDimension")
        colorCube.setValue(data, forKey: "inputCubeData")
        colorCube.setValue(target.ciImage, forKey: kCIInputImageKey)
        if let outImage = colorCube.outputImage {
            let context = CIContext(options: nil)
            let outputImageRef = context.createCGImage(outImage, from: outImage.extent)
            target.imageView.image = UIImage(cgImage: outputImageRef!)
        }
    }
    
    /// Convering HSV points to RGB
    ///
    /// - Parameters:
    ///   - h: Hue
    ///   - s: Saturation
    ///   - v: Brightness
    /// - Returns: (r:Red,g:Green,b:Blue)
    func HSVtoRGB(_ h : Float, s : Float, v : Float) -> (r : Float, g : Float, b : Float) {
        var r : Float = 0
        var g : Float = 0
        var b : Float = 0
        let C = s * v
        let HS = h * 6.0
        let X = C * (1.0 - fabsf(fmodf(HS, 2.0) - 1.0))
        if (HS >= 0 && HS < 1) {
            r = C
            g = X
            b = 0
        } else if (HS >= 1 && HS < 2) {
            r = X
            g = C
            b = 0
        } else if (HS >= 2 && HS < 3) {
            r = 0
            g = C
            b = X
        } else if (HS >= 3 && HS < 4) {
            r = 0
            g = X
            b = C
        } else if (HS >= 4 && HS < 5) {
            r = X
            g = 0
            b = C
        } else if (HS >= 5 && HS < 6) {
            r = C
            g = 0
            b = X
        }
        let m = v - C
        r += m
        g += m
        b += m
        return (r, g, b)
    }
    
    
    /// Converting RGB points to HSV
    ///
    /// - Parameters:
    ///   - r: Red Color
    ///   - g: Green Color
    ///   - b: Blue Color
    /// - Returns: (h:Hue,s:Saturation,v:brightness)
    func RGBtoHSV(_ r : Float, g : Float, b : Float) -> (h : Float, s : Float, v : Float) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return (Float(h), Float(s), Float(v))
    }
}

extension ChangeColorViewController : SwiftHUEColorPickerDelegate {
    // MARK: - SwiftHueColorPickerDelegate
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType)
    {
        currrentColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.color:
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            
            break
        case SwiftHUEColorPicker.PickerType.saturation:
            horizontalColorPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            
            break
        case SwiftHUEColorPicker.PickerType.brightness:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            
            break
        case SwiftHUEColorPicker.PickerType.alpha:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            
            break
        }
    }
}


