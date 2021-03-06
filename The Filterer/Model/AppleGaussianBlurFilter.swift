//
//  AppleGaussianBlurFilter.swift
//  The Filterer
//
//  Created by Alexander on 03.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class AppleGaussianBlurFilter: Filter {
    let settings = [FilterSetting(title: "Radius", minValue: 0.0, maxValue: 20.0, defaultValue: 10.0)]
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return settings
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: @escaping (NSImage?) -> Void) {
        
        Thread.detachNewThread {
            let imageToBlur = CIImage(data: image.tiffRepresentation!)
            let blurfilter = CIFilter(name: "CIGaussianBlur")
            blurfilter?.setValue(imageToBlur, forKey: "inputImage")
            blurfilter?.setValue(NSNumber(value: (settings[0] as! Double)), forKey: "inputRadius")
            let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage?
            
            let rep = NSCIImageRep(ciImage: resultImage!)
            let newImage = NSImage(size: rep.size)
            newImage.addRepresentation(rep)
            DispatchQueue.main.async(execute: {() -> Void in
                callback(newImage)
            })
        }
    }
}
