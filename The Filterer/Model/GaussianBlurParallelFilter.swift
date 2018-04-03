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
    
    override func getFilterSettings() -> Array<FilterSetting>? {
        return [FilterSetting(title: "Интенсивность (%)", minValue: 0.0, maxValue: 20.0), FilterSetting(title: "Кол-во потоков", minValue: 1, maxValue: 12)]
    }
    
    //    override func filterImage(_ image: NSImage, withSettings settings: Array<Any?>, callback: (NSImage?) -> Void) {
    //
    //    }
}
