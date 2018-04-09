//
//  GaussianBlurFilter.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class GaussianBlurFilter: Filter {
    
    var curSettings: Array<Any?>?
    
    private var radius: Int = 0
    private var kernel = [[0.0]]
    private var currentImage: NSImage?
    private var pixelData: [UInt8]?
    
    
    let settings = [FilterSetting(title: "Radius", minValue: 0.0, maxValue: 20.0, defaultValue: 10.0)]
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return settings
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
        
        radius = Int((Double(image.size.width) * ((settings[0] as! Double) / 100.0)) / 2.0)
        currentImage = image
        kernel = calculateKernel()!
        pixelData = pixelData(image)
        
        let newPixelData = runFilterEngine()
        let finalImage = NSImage.imageFromPixels(newPixelData, imageSize: image.size)
        
        callback(finalImage)
    }
    
    func calculateKernel() -> [[Double]]? {
        var kernelArray = [[Double]]()
        var sigma = Double(radius) / 4.0
        if sigma < 1.0 {
            sigma = 1.0
        }
        
        for i in 0..<(radius * 2 + 1) {
            var innerArray = [Double]()
            for j in 0..<(radius * 2 + 1) {
                let ePow = ((pow(Double(j - radius), 2.0) + pow(Double(i - radius), 2.0)) / (2 * pow(sigma, 2.0)))
                let kernelValue = (1.0 / (2.0 * Double.pi * pow(sigma, 2.0))) * pow(M_E, -ePow)
                
                innerArray.append(kernelValue)
            }
            kernelArray.append(innerArray)
        }
        
        return kernelArray
    }
    
    func runFilterEngine() -> [UInt8]? {
        var newPixelData = [UInt8]()
        for i in 0..<pixelData!.count {
            if (i + 1) % 4 == 0 {
                newPixelData.append(UInt8(pixelData![i]))
                continue
            }
            var curPixelValue = 0.0
            for x in stride(from: -radius, to: radius+1, by: 1) {
                for y in stride(from: -radius, to: radius+1, by: 1) {
                    curPixelValue += Double(pixelFor(index: i, x: x, y: y)) * kernel[x + radius][y + radius]
                }
            }
            newPixelData.append(UInt8(curPixelValue))
        }
        
        return newPixelData
    }
    
    func pixelFor(index: Int, x: Int, y: Int) -> Int {
        let width = Int(currentImage!.size.width) * 4
        let yShift = index + width * y
        if yShift < 0 || yShift >= pixelData!.count {
            return 0
        }
        
        let xShift = x * 4
        let xPos = index % width + xShift
        
        if xPos < 0 || xPos >= width {
            return 0
        }
        
        return Int(pixelData![yShift + xShift])
    }
}
