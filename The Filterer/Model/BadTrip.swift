//
//  GaussianBlurFilter.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class BadTrip: Filter {
    
    var curSettings: Array<Any?>?
    
    private var currentImage: NSImage?
    private var pixelData: [UInt8]?
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return nil
    }
    
    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
        
        currentImage = image
        pixelData = pixelData(image)
        
        let finalImage = NSImage.imageFromPixelsTrip(pixelData, imageSize: image.size)
        
        callback(finalImage)
    }
}

