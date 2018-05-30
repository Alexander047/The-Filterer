//
//  GaussianBlurParallelFilter.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class GaussianBlurParallelFilter: Filter {
    
    var curSettings: Array<Any?>?
    
    let settings = [FilterSetting(title: "Radius", minValue: 0.0, maxValue: 20.0, defaultValue: 2.0), FilterSetting(title: "Кол-во потоков", minValue: 1, maxValue: 12, defaultValue: 4)]
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return settings
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: @escaping (NSImage?) -> Void) {
        
        let radius = Int(settings[0] as! Double)
        let threads = Int(settings[1] as! Int)
        
        if let pixels = pixelData(image) {
            runFilterEngine(forPixels: pixels, threads: Int32(threads), radius: Int32(radius), width: Int32(image.size.width), height: Int32(image.size.height), callback: { newPixels in
                let finalImage = NSImage.imageFromUnsafePixels(newPixels, imageSize: image.size)
                callback(finalImage)
            })
        }
    }
    func runFilterEngine(forPixels pixels: [UInt8], threads: Int32, radius: Int32, width: Int32, height: Int32, callback: @escaping (UnsafeMutablePointer<UInt8>?) -> Void) {
        
        var swiftInput: [UInt8] = pixels
        
        var uint8Pointer: UnsafeMutablePointer<UInt8>!
        uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: swiftInput.count)
        uint8Pointer.initialize(from: &swiftInput, count: swiftInput.count)
        
        let engine = GaussianBlurParallelEngine()
        engine.runGaussianBlurFilter(&uint8Pointer[0], threadsN: threads, arSize: Int32(swiftInput.count), width: width, height: height, radius: radius) { newPixels in
            callback(newPixels)
        }
    }
//    func runFilterEngine(forPixels pixels: [UInt8], radius: Int32, width: Int32, height: Int32) -> UnsafeMutablePointer<UInt8>? {
//
//        var swiftInput: [UInt8] = pixels
//
//        var uint8Pointer: UnsafeMutablePointer<UInt8>!
//        uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: swiftInput.count)
//        uint8Pointer.initialize(from: &swiftInput, count: swiftInput.count)
//
////        runGaussianBlurParallelFilter(&uint8Pointer[0], Int32(swiftInput.count), width, height, radius)
//
//        return nil
//    }
}
