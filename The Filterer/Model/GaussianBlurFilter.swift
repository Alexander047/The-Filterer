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
    
    
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return [FilterSetting(title: "Интенсивность (%)", minValue: 0.0, maxValue: 20.0), FilterSetting(title: "Инверсия цветов", minValue: false, maxValue: true), FilterSetting(title: "Кол-во потоков", minValue: 1, maxValue: 12), FilterSetting(title: "Яркость (%)", minValue: 0.0, maxValue: 100.0)]
    }
    
//    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
////        var imageToBlur = CIImage(CGImage: image)
//        var blurfilter = CIFilter(name: "CIGaussianBlur")
//        blurfilter?.setValue(image, forKey: "inputImage")
//        var resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage?
//        var blurredImage = NSImage(cgImage: CGImage(resultImage!), size: NSSize(width: 100.0, height: 100.0))
//        callback(blurredImage)
//    }
}
