//
//  GaussianBlurParallelEngine.m
//  The Filterer
//
//  Created by Alexander on 29.05.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "GaussianBlurParallelEngine.h"

@interface GaussianBlurParallelEngine() {
    int threads;
    int size;
    int radius;
    int imgWidth;
    int imgHeight;
    uint8_t *pixelData;
    float kernel[41][41];
    uint8_t *newPixelDataRef;
}

@property (atomic, strong) void (^successBlock)(uint8_t *);
@property (atomic) NSInteger busyThreads;

@end

@implementation GaussianBlurParallelEngine

- (void)runGaussianBlurFilter:(uint8_t *)array threadsN:(int)threadsN arSize:(int)arSize width:(int)imageWidth height:(int)imageHeight radius:(int)rad callback:(void (^)(uint8_t *))callback {
    threads = threadsN;
    size = arSize;
    radius = rad;
    imgWidth = imageWidth;
    imgHeight = imageHeight;
    pixelData = array;
    _successBlock = callback;
    
    [NSThread detachNewThreadWithBlock:^{
        [self initKernel];
//        uint8_t newPixelData[size];
        uint8_t *newPixelData = (uint8_t *)malloc(sizeof(uint8_t) * size);
        newPixelDataRef = &newPixelData[0];
        
        for (int trad = 0; trad < threads; trad++) {
            _busyThreads++;
            int curThread = trad;
            [NSThread detachNewThreadWithBlock:^{
                for (int i = curThread; i < size; i += threads) {
                    if ((i + 1) % 4 == 0) {
                        newPixelDataRef[i] = pixelData[i];
                        continue;
                    }
                    float curPixelValue = 0.0;
                    for (int x = -radius; x <= radius; x++) {
                        for (int y = -radius; y <= radius; y++) {
                            uint8_t pixelVal;
                            int width = imgWidth * 4;
                            int yShift = i + width * y;
                            if (yShift < 0 || yShift >= size) {
                                pixelVal = 0;
                            } else {
                                int xShift = x * 4;
                                int xPos = i % width + xShift;
                                if (xPos < 0 || xPos >= width) {
                                    pixelVal = 0;
                                } else {
                                    pixelVal = pixelData[yShift + xShift];
                                }
                            }
                            curPixelValue += (float)pixelVal * kernel[x + radius][y + radius];
                        }
                    }
                    newPixelDataRef[i] = (uint8_t)curPixelValue;
                }
                _busyThreads--;
//                if (_busyThreads == 0) {
//                    [self performSelectorOnMainThread:@selector(performCallback) withObject:nil waitUntilDone:YES];
//                }
                [self performSelectorOnMainThread:@selector(endThread:) withObject:[NSThread currentThread] waitUntilDone:NO];
            }];
        }
        while (_busyThreads != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }
        [self performSelectorOnMainThread:@selector(performCallback) withObject:nil waitUntilDone:YES];
    }];
}

- (void)endThread:(NSThread *)thread {
    if (![thread isCancelled]) {
        [thread cancel];
    }
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
