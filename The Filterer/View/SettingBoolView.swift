//
//  SettingBoolView.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class SettingBoolView: NSView {

    @IBOutlet weak var checkButton: NSButton!
    
    class func initFromNib(_ curSetting: FilterSetting) -> SettingBoolView? {
        
        var viewArray: NSArray?
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "SettingBoolView"), owner: nil, topLevelObjects: &viewArray)
        
        var neededView: SettingBoolView?
        viewArray!.forEach { curView in
            if curView is SettingBoolView {
                neededView = (curView as! SettingBoolView)
            }
        }
        
        neededView!.checkButton.title = curSetting.title!
        
        return neededView
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
}
