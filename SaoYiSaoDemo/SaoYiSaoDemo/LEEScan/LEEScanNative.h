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
 @brief  初始化采集相机
 @param preView 视频显示区域
 @param objType 识别码类型：如果为nil，默认支持很多类型。(二维码如QR：AVMetadataObjectTypeQRCode,条码如：AVMetadataObjectTypeCode93Code
 @param cropRect 识别区域，值CGRectZero 全屏识别
 @param block   识别结果
 @return LBXScanNative的实例
 */
- (instancetype)initWithPreView:(UIView*)preView ObjectType:(NSArray*)objType cropRect:(CGRect)cropRect
                        success:(void(^)(NSArray<NSString*> *array))block;

/**
 *  开始扫码
 */
- (void)startScan;

/**
 *  停止扫码
 */
- (void)stopScan;
/**
 *  自动根据闪关灯状态去改变
 */
- (void)changeTorch;

/**
 @brief 拉近拉远镜头
 @param scale 系数
 */
- (void)setVideoScale:(CGFloat)scale;


/**
 识别QR二维码图片,ios8.0以上支持
 
 @param image 图片
 @param block 返回识别结果
 */
+ (void)recognizeImage:(UIImage*)image success:(void(^)(NSArray *result))block;
@end
