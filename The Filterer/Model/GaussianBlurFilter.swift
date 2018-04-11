//
//  GaussianBlurFilter.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa
import Foundation

class GaussianBlurFilter: Filter {
    
    var curSettings: Array<Any?>?
    
    let settings = [FilterSetting(title: "Radius", minValue: 0.0, maxValue: 20.0, defaultValue: 2.0)]
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return settings
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
        
        let radius = Int(settings[0] as! Double)
        
        if let pixels = pixelData(image) {
            let newPixelData = runFilterEngine(forPixels: pixels, radius: Int32(radius), width: Int32(image.size.width), height: Int32(image.size.height))
            let finalImage = NSImage.imageFromUnsafePixels(newPixelData, imageSize: image.size)
            callback(finalImage)
        }
    }
    
    func runFilterEngine(forPixels pixels: [UInt8], radius: Int32, width: Int32, height: Int32) -> UnsafeMutablePointer<UInt8>? {
        
        var swiftInput: [UInt8] = pixels
        
        var uint8Pointer: UnsafeMutablePointer<UInt8>!
        uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: swiftInput.count)
        uint8Pointer.initialize(from: &swiftInput, count: swiftInput.count)
        
        let newPixelData = runGaussianBlurFilter(&uint8Pointer[0], Int32(swiftInput.count), width, height, radius)
     
        return newPixelData
    }
}
