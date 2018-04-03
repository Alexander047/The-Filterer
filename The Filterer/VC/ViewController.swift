//
//  ViewController.swift
//  The Filterer
//
//  Created by Alexander on 01.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var mainImageView: NSImageView!
    @IBOutlet weak var settingsView: NSView!
    
    var filteredImage: NSImage!
    var nonfilteredImage: NSImage!
    var settingsViewArray: Array<NSView?>? = []
    
    let gaussianBlur = GaussianBlurFilter()
    let gaussianBlurParallel = GaussianBlurParallelFilter()
    
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
        
    }
    
    func drawFilterControls() {
        
        settingsViewArray?.forEach { view in
            view?.removeFromSuperview()
        }
        
        settingsViewArray?.removeAll()
        var curControlOrigin: CGFloat = settingsView!.frame.size.height
        let settingsArray = currentFilter?.getFilterSettings()
        
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
    
    
    
    
    
    @IBAction func didSelectGaussianBlur(_ sender: Any) {
        currentFilter = gaussianBlur
        mainImageView.image = nonfilteredImage
    }
    
    @IBAction func didSelectGaussianBlurParallel(_ sender: Any) {
        currentFilter = gaussianBlurParallel
        mainImageView.image = nonfilteredImage
    }
    
    
    
    
    
    @IBAction func didDragNewImage(_ sender: NSImageView) {
        nonfilteredImage = sender.image
        NSLog("Dragged an image. \(nonfilteredImage!)")
    }
    
    @IBAction func didPress(_ sender: NSButton) {
        
    }
    
    
    
    
    override var representedObject: Any? {
        didSet {
        
        }
    }


}

