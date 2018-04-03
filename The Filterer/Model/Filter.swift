//
//  Filter.swift
//  The Filterer
//
//  Created by Alexander on 01.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

struct FilterSetting {
    var title: String?
    var minValue: Any?
    var maxValue: Any?
}

class Filter: NSObject {
    
    func getFilterSettings() -> Array<FilterSetting>? {
        return [FilterSetting(title: "Generic Title Double", minValue: 0.0, maxValue: 1.0), FilterSetting(title: "Generic Title Bool", minValue: false, maxValue: true), FilterSetting(title: "Generic Title Integer", minValue: 0, maxValue: 1)]
    }
    
    func filterImage(_ image: NSImage, withSettings settings:Array<Any?>, callback: (NSImage?) -> Void) {
        let newImage = image
        
        callback(newImage)
    }
    
    
}
