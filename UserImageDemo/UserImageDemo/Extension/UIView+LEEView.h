//
//  UIView+LEEView.h
//  LEEAddition
//
//  Created by 李江波 on 2017/6/17.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface UIView (LEEView)
/*
 简易frame调用
 */
@property(nonatomic, assign) CGFloat Lee_X;
@property(nonatomic, assign) CGFloat Lee_Y;
@property(nonatomic, assign) CGFloat Lee_Width;
@property(nonatomic, assign) CGFloat Lee_Height;
@property(nonatomic, assign) CGFloat Lee_CenterX;
@property(nonatomic, assign) CGFloat Lee_CenterY;
@property(nonatomic, assign) CGSize Lee_Size;


/**
 边框宽度
 */
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 边框颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 圆角
 */
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;


@property(nonatomic, assign) IBInspectable BOOL lee_hasShadown;

/**
 返回视图截图

 @return 图片
 */
- (UIImage *)lee_snapshotImage;
@end


