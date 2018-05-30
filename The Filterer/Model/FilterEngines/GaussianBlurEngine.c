//
//  GaussianBlurEngine.swift
//  The Filterer
//
//  Created by Alexander on 11.04.2018.
//  Copyright © 2018 Alexander. All rights reserved.
//

#include <stdio.h>
#include <stdint.h>
#include <math.h>

int size;
int radius;
int imgWidth;
int imgHeight;
uint8_t *pixelData;
float kernel[41][41];

uint8_t pixelFor(int index, int x, int y);

void initKernel() {
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

uint8_t * runGaussianBlurFilter(uint8_t *array, int arraySize, int imageWidth, int imageHeight, int rad) {
    size = arraySize;
    radius = rad;
    imgWidth = imageWidth;
    imgHeight = imageHeight;
    pixelData = array;
    
    initKernel();
    
    uint8_t newPixelData[size];
    for (int i = 0; i < size; i++) {
        if ((i + 1) % 4 == 0) {
            newPixelData[i] = pixelData[i];
            continue;
        }
        float curPixelValue = 0.0;
        for (int x = -radius; x <= radius; x++) {
            for (int y = -radius; y <= radius; y++) {
                curPixelValue += (float)pixelFor(i, x, y) * kernel[x + radius][y + radius];
            }
        }
        newPixelData[i] = (uint8_t)curPixelValue;
    }
    
    return &newPixelData[0];
}

void runGaussianBlurParallelFilter(uint8_t *array, int arraySize, int imageWidth, int imageHeight, int rad) {
    size = arraySize;
    radius = rad;
    imgWidth = imageWidth;
    imgHeight = imageHeight;
    pixelData = array;
    
    initKernel();
    
    
    
    uint8_t newPixelData[size];
    for (int i = 0; i < size; i++) {
        if ((i + 1) % 4 == 0) {
            newPixelData[i] = pixelData[i];
            continue;
        }
        float curPixelValue = 0.0;
        for (int x = -radius; x <= radius; x++) {
            for (int y = -radius; y <= radius; y++) {
                curPixelValue += (float)pixelFor(i, x, y) * kernel[x + radius][y + radius];
            }
        }
        newPixelData[i] = (uint8_t)curPixelValue;
    }
}

uint8_t pixelFor(int index, int x, int y) {
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
    
    return (uint8_t)pixelData[yShift + xShift];
}
