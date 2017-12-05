//
//  LEEScanViewStyle.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanViewStyle.h"

@implementation LEEScanViewStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isNeedShowRetangle = YES;
        _centerUpOffset = 44;
        _xScanRetangleOffset = 60.0;
        _colorRetangleLine = [UIColor whiteColor];
        
        _photoFrameAngleStyle = LEEScanViewPhotoFrameAngleStyle_Outer;
        _colorAngle = [UIColor colorWithRed:0 green:167./255. blue:231./255. alpha:1.0];
        _photoframeAngleW = 24;
        _photoframeAngleH = 24;
        _photoframeLineW = 6;
        
        _notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _animationStyle = LEEScanViewAnimationStyle_LineMove;
        _animationImage = [UIImage imageNamed:@"qrcode_scan_light_green"];
        
//        _animationStyle = LEEScanViewAnimationStyle_NetGrid;
//        _animationImage = [UIImage imageNamed:@"qrcode_scan_full_net"];
    }
    return self;
}

@end
