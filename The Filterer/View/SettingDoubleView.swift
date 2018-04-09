//
//  SettingDoubleView.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class SettingDoubleView: NSView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var sliderView: NSSlider!
    
    var curSetting: FilterSetting!
    
    class func initFromNib(_ curSetting: FilterSetting) -> SettingDoubleView? {
        
        var viewArray: NSArray?
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "SettingDoubleView"), owner: nil, topLevelObjects: &viewArray)
        
        var neededView: SettingDoubleView?
        viewArray!.forEach { curView in
            if curView is SettingDoubleView {
                neededView = (curView as! SettingDoubleView)
            }
        }
        
        neededView!.curSetting = curSetting
        neededView!.titleLabel.stringValue = String(curSetting.title! + ": " + String(Int(curSetting.defaultValue as! Double)))
        neededView!.sliderView.minValue = curSetting.minValue as! Double
        neededView!.sliderView.maxValue = curSetting.maxValue as! Double
        neededView!.sliderView.integerValue = Int(curSetting.defaultValue as! Double)
        
        return neededView
    }
    
    @IBAction func sliderValueDidChange(_ sender: NSSlider) {
        titleLabel.stringValue = String(curSetting.title! + ": " + String(sliderView.integerValue))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
