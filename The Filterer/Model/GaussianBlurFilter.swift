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
    
    private var radius: Int = 0
    private var kernel = [[0.0]]
    private var currentImage: NSImage?
    private var pixelData: [UInt8] = [0]
    
    
    let settings = [FilterSetting(title: "Radius", minValue: 0.0, maxValue: 20.0, defaultValue: 2.0)]
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return settings
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
        
        radius = Int(settings[0] as! Double)
        currentImage = image
        pixelData = pixelData(image)!
        
        let newPixelData = runFilterEngine()
        let finalImage = NSImage.imageFromUnsafePixels(newPixelData, imageSize: image.size)
        
        callback(finalImage)
    }
    
    func runFilterEngine() -> UnsafeMutablePointer<UInt8>? {
        
        var swiftInput: [UInt8] = pixelData
        
        var uint8Pointer: UnsafeMutablePointer<UInt8>!
        uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: swiftInput.count)
        uint8Pointer.initialize(from: &swiftInput, count: swiftInput.count)
        
        let newPixelData = getInput(&uint8Pointer[0], Int32(swiftInput.count), Int32(currentImage!.size.width), Int32(currentImage!.size.height), Int32(radius))

        return newPixelData
    }
}
