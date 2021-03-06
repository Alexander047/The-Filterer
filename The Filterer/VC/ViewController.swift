//
//  ViewController.swift
//  The Filterer
//
//  Created by Alexander on 01.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var mainImageView: NSImageView!
    @IBOutlet weak var settingsView: NSView!
    @IBOutlet weak var durationLabel: NSTextField!
    @IBOutlet weak var applyFilterButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var filteredImage: NSImage!
    var nonfilteredImage: NSImage!
    var settingsViewArray: Array<NSView?>? = []
    
    let gaussianBlur = GaussianBlurFilter()
    let gaussianBlurApple = AppleGaussianBlurFilter()
    let gaussianBlurParallel = GaussianBlurParallelFilter()
    let badTrip = BadTrip()
    
    var currentFilter: Filter? {
        didSet {
            drawFilterControls()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentFilter = gaussianBlur
        
        initGUI()
    }
    
    func initGUI() {
//        var swiftInput: [UInt8] = [12, 13, 15]
//        
//        var uint8Pointer: UnsafeMutablePointer<UInt8>!
//        uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: swiftInput.count)
//        uint8Pointer.initialize(from: &swiftInput, count: swiftInput.count)
//        
//        getInput(&uint8Pointer[0], Int32(swiftInput.count))
        
//        print(output)
    }
    
    func drawFilterControls() {
        
        settingsViewArray?.forEach { view in
            view?.removeFromSuperview()
        }
        durationLabel.stringValue = ""
        
        settingsViewArray?.removeAll()
        var curControlOrigin: CGFloat = settingsView!.frame.size.height
        let settingsArray = currentFilter?.getFilterSettings()
        
        if settingsArray != nil {
            settingsArray!.forEach { curSetting in
                
                var curSettingView: NSView?
                
                switch curSetting.minValue! {
                case is Bool:
                    curSettingView = SettingBoolView.initFromNib(curSetting)
                case is Int:
                    curSettingView = SettingIntegerView.initFromNib(curSetting)
                case is Double:
                    curSettingView = SettingDoubleView.initFromNib(curSetting)
                default:
                    print("idk :/")
                }
                
                curControlOrigin -= curSettingView!.frame.size.height
                curSettingView!.setFrameOrigin(NSPoint(x: 0.0, y: curControlOrigin))
                settingsView.addSubview(curSettingView!)
                settingsViewArray?.append(curSettingView!)
            }
        }
    }
    
    
    
    
    
    @IBAction func didSelectGaussianBlur(_ sender: Any) {
        currentFilter = gaussianBlur
        mainImageView.image = nonfilteredImage
    }
    
    @IBAction func didSelectGaussianBlurApple(_ sender: Any) {
        currentFilter = gaussianBlurApple
        mainImageView.image = nonfilteredImage
    }
    
    @IBAction func didSelectGaussianBlurParallel(_ sender: Any) {
        currentFilter = gaussianBlurParallel
        mainImageView.image = nonfilteredImage
    }
    
    @IBAction func didSelectBadTripFilter(_ sender: Any) {
        currentFilter = badTrip
        mainImageView.image = nonfilteredImage
    }
    
    @IBAction func applyFilter(_ sender: NSButton) {
        if nonfilteredImage == nil {
            return
        }
        self.progressIndicator.startAnimation(nil)
        self.progressIndicator.isHidden = false
        applyFilterButton.isEnabled = false
        self.durationLabel.stringValue = ""
        
        var settings: Array<Any?>? = []
        settingsViewArray?.forEach({ view in
            switch view! {
            case is SettingBoolView:
                settings?.append((view as! SettingBoolView).checkButton.integerValue)
            case is SettingIntegerView:
                settings?.append((view as! SettingIntegerView).stepperView.integerValue)
            case is SettingDoubleView:
                settings?.append((view as! SettingDoubleView).sliderView.doubleValue)
            default:
                print("idk :/")
            }
        })
        
        let startMoment = NSDate()
        
        currentFilter?.filterImage(nonfilteredImage!, withSettings: settings!, callback: { newImage in
            self.filteredImage = newImage
            self.mainImageView.image = newImage
            
            let timeValue = String(format: "%.4f", (-startMoment.timeIntervalSinceNow * 1000.0))
            self.durationLabel.stringValue = "Duration: \(timeValue)ms"
            
            NSLog("\n\nFiltered an image. \n\n\(self.filteredImage!)\n\n")
            self.progressIndicator.stopAnimation(nil)
            self.progressIndicator.isHidden = true
            self.applyFilterButton.isEnabled = true
        })
    }
    
    
    
    
    @IBAction func didDragNewImage(_ sender: NSImageView) {
        nonfilteredImage = sender.image
        NSLog("\n\nDragged an image. \n\n\(nonfilteredImage!)\n\n")
    }
    
    @IBAction func didPress(_ sender: NSButton) {
        
    }
    
    
    
    
    override var representedObject: Any? {
        didSet {
        
        }
    }


}

