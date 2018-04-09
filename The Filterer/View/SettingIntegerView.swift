//
//  SettingIntegerView.swift
//  The Filterer
//
//  Created by Alexander on 02.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class SettingIntegerView: NSView {

    @IBOutlet weak var stepperView: NSStepper!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var valueLabel: NSTextField!
    
    class func initFromNib(_ curSetting: FilterSetting) -> SettingIntegerView? {
        
        var viewArray: NSArray?
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "SettingIntegerView"), owner: nil, topLevelObjects: &viewArray)
        
        var neededView: SettingIntegerView?
        viewArray!.forEach { curView in
            if curView is SettingIntegerView {
                neededView = (curView as! SettingIntegerView)
            }
        }
        
        neededView!.titleLabel.stringValue = curSetting.title! + ":"
        neededView!.stepperView.minValue = Double(curSetting.minValue as! Int)
        neededView!.stepperView.maxValue = Double(curSetting.maxValue as! Int)
        neededView!.stepperView.integerValue = curSetting.defaultValue as! Int
        
        return neededView
    }
    
    @IBAction func stepperValueDidChange(_ sender: NSStepper) {
        valueLabel.stringValue = stepperView.stringValue
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
