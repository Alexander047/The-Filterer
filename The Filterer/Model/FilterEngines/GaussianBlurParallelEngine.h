//
//  GaussianBlurParallelEngine.h
//  The Filterer
//
//  Created by Alexander on 29.05.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdint.h>

@interface GaussianBlurParallelEngine : NSObject

- (void)runGaussianBlurFilter:(uint8_t *)array threadsN:(int)threads arSize:(int)size width:(int)width height:(int)height radius:(int)rad callback:(void (^)(uint8_t *))callback;

@end
