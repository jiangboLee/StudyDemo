//
//  LEEScanNative.h
//  SaoYiSaoDemo
//
//  Created by 李江波 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LEEScanNative : NSObject
/**
 识别QR二维码图片,ios8.0以上支持
 
 @param image 图片
 @param block 返回识别结果
 */
+ (void)recognizeImage:(UIImage*)image success:(void(^)(NSArray *result))block;
@end
