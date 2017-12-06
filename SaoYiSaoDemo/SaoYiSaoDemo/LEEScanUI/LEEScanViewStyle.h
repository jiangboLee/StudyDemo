//
//  LEEScanViewStyle.h
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LEEScanViewPhotoFrameAngleStyle_Inner,//内嵌，一般不显示矩形框情况下
    LEEScanViewPhotoFrameAngleStyle_Outer,//外嵌,包围在矩形框的4个角
    LEEScanViewPhotoFrameAngleStyle_On,//在矩形框的4个角上，覆盖
} LEEScanViewPhotoFrameAngleStyle;

typedef enum : NSUInteger {
    LEEScanViewAnimationStyle_LineMove, //线条上下移动
    LEEScanViewAnimationStyle_NetGrid, //网格
    LEEScanViewAnimationStyle_LineStill, //线条停止在扫码区域中央
    LEEScanViewAnimationStyle_None //无动画
} LEEScanViewAnimationStyle;


@interface LEEScanViewStyle : NSObject

#pragma mark -中心位置矩形框
/**
 @brief  是否需要绘制扫码矩形框，默认YES
 */
@property(nonatomic, assign) BOOL isNeedShowRetangle;

/**
 @brief  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，< 0 表示扫码区域下移, >0 表示扫码区域上移
 */
@property(nonatomic, assign) CGFloat centerUpOffset;

/**
 *  矩形框(视频显示透明区)域离界面左边及右边距离，默认60
 */
@property(nonatomic, assign) CGFloat xScanRetangleOffset;

/**
 @brief  矩形框线条颜色
 */
@property(nonatomic, strong) UIColor *colorRetangleLine;

#pragma mark -矩形框(扫码区域)周围4个角

/**
 扫码区域的4个角类型
 */
@property(nonatomic, assign) LEEScanViewPhotoFrameAngleStyle photoFrameAngleStyle;
//4个角的颜色
@property(nonatomic, strong) UIColor* colorAngle;

//扫码区域4个角的宽度和高度
@property(nonatomic, assign) CGFloat photoframeAngleW;
@property(nonatomic, assign) CGFloat photoframeAngleH;
/**
 扫码区域4个角的线条宽度,默认6，建议8到4之间
 */
@property(nonatomic, assign) CGFloat photoframeLineW;

#pragma mark -非识别区域颜色,默认 RGBA (0,0,0,0.5)

/**
 非识别区域颜色
 must be create by [UIColor colorWithRed: green: blue: alpha:]
 */
@property(nonatomic, strong) UIColor *notRecoginitonArea;

#pragma mark: - 动画效果

/**
 扫码动画效果:线条或网格
 */
@property(nonatomic, assign) LEEScanViewAnimationStyle animationStyle;
/**
 *  动画效果的图像，如线条或网格的图像，如果为nil，表示不需要动画效果
 */
@property (nonatomic,strong,nullable) UIImage *animationImage;

@end











