//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stdio.h>
#include <stdint.h>

uint8_t * runGaussianBlurFilter(uint8_t *array, int size, int imageWidth, int imageHeight, int radius);
void runGaussianBlurParallelFilter(uint8_t *array, int size, int imageWidth, int imageHeight, int radius);

