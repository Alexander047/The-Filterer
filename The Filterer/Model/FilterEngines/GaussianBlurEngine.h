//
//  GaussianBlurEngine.h
//  The Filterer
//
//  Created by Alexander on 13.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdint.h>

@interface GaussianBlurEngine : NSObject

- (void)runGaussianBlurFilter:(uint8_t *)array arSize:(int)size width:(int)width height:(int)height radius:(int)rad callback:(void (^)(uint8_t *))callback;


@end
