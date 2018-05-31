//
//  GaussianBlurEngine.m
//  The Filterer
//
//  Created by Alexander on 13.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "GaussianBlurEngine.h"

@interface GaussianBlurEngine() {
    int size;
    int radius;
    int imgWidth;
    int imgHeight;
    uint8_t *pixelData;
    float kernel[41][41];
    uint8_t *newPixelDataRef;
}

@property (atomic, strong) void (^successBlock)(uint8_t *);
//@property (nonatomic) int size;
//@property (nonatomic) int radius;
//@property (nonatomic) int imgWidth;
//@property (nonatomic) int imgHeight;
//@property (nonatomic) uint8_t *pixelData;
//@property (nonatomic) float kernel[41][41];

@end

@implementation GaussianBlurEngine


- (void)runGaussianBlurFilter:(uint8_t *)array arSize:(int)arSize width:(int)imageWidth height:(int)imageHeight radius:(int)rad callback:(void (^)(uint8_t *))callback {
    size = arSize;
    radius = rad;
    imgWidth = imageWidth;
    imgHeight = imageHeight;
    pixelData = array;
    _successBlock = callback;
    
//    uint8_t newPixelData[size];
//    newPixelDataRef = &newPixelData[0];
    
    [NSThread detachNewThreadWithBlock:^{
        [self initKernel];
        uint8_t *newPixelData = (uint8_t *)malloc(sizeof(uint8_t) * size);
        for (int i = 0; i < size; i++) {
            if ((i + 1) % 4 == 0) {
                newPixelData[i] = pixelData[i];
                continue;
            }
            float curPixelValue = 0.0;
            for (int x = -radius; x <= radius; x++) {
                for (int y = -radius; y <= radius; y++) {
                    curPixelValue += (float)[self pixelFor:i x:x y:y] * kernel[x + radius][y + radius];
                }
            }
            newPixelData[i] = (uint8_t)curPixelValue;
        }
        newPixelDataRef = &newPixelData[0];
        [self performSelectorOnMainThread:@selector(performCallback) withObject:nil waitUntilDone:YES];
        
    }];
}

- (void)performCallback {
    if (_successBlock) {
        _successBlock(newPixelDataRef);
    }
}

- (void)initKernel {
    
    float sigma = (float)radius / 4.0;
    if (sigma < 1.0) {
        sigma = 1.0;
    }
    
    for (int i = -radius; i <= radius; i++) {
        for (int j = -radius; j <= radius; j++) {
            float ePow = ((pow((float)(j), 2.0) + pow((float)(i), 2.0)) / (2 * pow(sigma, 2.0)));
            float kernelValue = (1.0 / (2.0 * M_PI * pow(sigma, 2.0))) * pow(M_E, -ePow);
            kernel[i + radius][j + radius] = kernelValue;
        }
    }
}

- (uint8_t)pixelFor:(int)index x:(int)x y:(int)y {
    int width = imgWidth * 4;
    int yShift = index + width * y;
    if (yShift < 0 || yShift >= size) {
        return 0;
    }
    
    int xShift = x * 4;
    int xPos = index % width + xShift;
    
    if (xPos < 0 || xPos >= width) {
        return 0;
    }
    
    return pixelData[yShift + xShift];
}

@end
