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
    var defaultValue: Any?
}

class Filter: NSObject {
    
    func getFilterSettings() -> Array<FilterSetting>? {
        return [FilterSetting(title: "Generic Title Double", minValue: 0.0, maxValue: 1.0, defaultValue: 0.0), FilterSetting(title: "Generic Title Bool", minValue: false, maxValue: true, defaultValue: false), FilterSetting(title: "Generic Title Integer", minValue: 0, maxValue: 1, defaultValue: 0)]
    }
    
    func filterImage(_ image: NSImage, withSettings settings:Array<Any?>, callback: (NSImage?) -> Void) {
        let newImage = image
        
        callback(newImage)
    }
    
    
    func pixelData(_ image: NSImage?) -> [UInt8]? {
        let size = image!.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = image!.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        
        return pixelData
    }
}


extension NSImage {
    class func imageFromPixels(_ pixels: [UInt8]?, imageSize size: NSSize) -> NSImage? {
//        let unsafePixels: UnsafePointer<UInt8> = pixels![0]
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitsPerComponent = 8 //number of bits in UInt8
        let bitsPerPixel = 4 * bitsPerComponent //ARGB uses 4 components
        let bytesPerRow = bitsPerPixel * Int(size.width) / 8 // bitsPerRow / 8 (in some cases, you need some paddings)
        let providerRef = CGDataProvider(
            data: NSData(bytes: pixels, length: Int(size.height) * bytesPerRow) //Do not put `&` as pixels is already an `UnsafePointer`
        )
        
        let cgim = CGImage(
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow, //->not bits
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return NSImage(cgImage: cgim!, size: size)
    }
    
    class func imageFromUnsafePixels(_ pixels: UnsafeMutablePointer<UInt8>?, imageSize size: NSSize) -> NSImage? {
        //        let unsafePixels: UnsafePointer<UInt8> = pixels![0]
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitsPerComponent = 8 //number of bits in UInt8
        let bitsPerPixel = 4 * bitsPerComponent //ARGB uses 4 components
        let bytesPerRow = bitsPerPixel * Int(size.width) / 8 // bitsPerRow / 8 (in some cases, you need some paddings)
        let providerRef = CGDataProvider(
            data: NSData(bytes: pixels, length: Int(size.height) * bytesPerRow) //Do not put `&` as pixels is already an `UnsafePointer`
        )
        
        let cgim = CGImage(
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow, //->not bits
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return NSImage(cgImage: cgim!, size: size)
    }
    
    class func imageFromPixelsTrip(_ pixels: [UInt8]?, imageSize size: NSSize) -> NSImage? {
        //        let unsafePixels: UnsafePointer<UInt8> = pixels![0]
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8 //number of bits in UInt8
        let bitsPerPixel = 4 * bitsPerComponent //ARGB uses 4 components
        let bytesPerRow = bitsPerPixel * Int(size.width) / 8 // bitsPerRow / 8 (in some cases, you need some paddings)
        let providerRef = CGDataProvider(
            data: NSData(bytes: pixels, length: Int(size.height) * bytesPerRow) //Do not put `&` as pixels is already an `UnsafePointer`
        )
        
        let cgim = CGImage(
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow, //->not bits
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return NSImage(cgImage: cgim!, size: size)
    }
}
