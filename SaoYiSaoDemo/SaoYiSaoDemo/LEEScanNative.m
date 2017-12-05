//
//  LEEScanNative.m
//  SaoYiSaoDemo
//
//  Created by 李江波 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanNative.h"

@implementation LEEScanNative

+ (void)recognizeImage:(UIImage *)image success:(void(^)(NSArray *))block {
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray *mutableStr = [NSMutableArray array];
    for (int i = 0; i < features.count; i ++) {
        CIQRCodeFeature *feature = features[i];
        NSString *scannedResult = feature.messageString;
        [mutableStr addObject:scannedResult];
    }
    block(mutableStr.copy);
}
@end
