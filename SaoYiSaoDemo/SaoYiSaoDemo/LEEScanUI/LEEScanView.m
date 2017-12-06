//
//  LEEScanView.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanView.h"
#import "LEEScanViewStyle.h"
#import "LEEScanLineAnimation.h"
#import "LEEScanNetAnimation.h"

@interface LEEScanView()

//扫码区域各种参数
@property (nonatomic, strong,nullable) LEEScanViewStyle *viewStyle;
//扫码区域
@property (nonatomic,assign)CGRect scanRetangleRect;

//线条扫码动画封装
@property(nonatomic,strong,nullable) LEEScanLineAnimation *scanLineAnimation;
//网格扫码动画封装
@property(nonatomic,strong,nullable) LEEScanNetAnimation *scanNetAnimation;
//线条在中间位置，不移动
@property (nonatomic,strong,nullable)UIImageView *scanLineStill;

@end

@implementation LEEScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewStyle = [[LEEScanViewStyle alloc] init];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawScanRect];
}

- (void)drawScanRect {
    
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - self.viewStyle.xScanRetangleOffset * 2, self.frame.size.width - self.viewStyle.xScanRetangleOffset * 2);
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - self.viewStyle.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - self.viewStyle.xScanRetangleOffset;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    {//非扫码区域半透明
        const CGFloat *components = CGColorGetComponents(self.viewStyle.notRecoginitonArea.CGColor);
        
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat bule = components[2];
        CGFloat alpha = components[3];
        
        CGContextSetRGBFillColor(context, red, green, bule, alpha);
        
        //填充矩形
        //上
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        //左 加了一点点，不然有缝隙，why?
        rect = CGRectMake(0, YMinRetangle - 0.05, self.viewStyle.xScanRetangleOffset, sizeRetangle.height + 0.1);
        CGContextFillRect(context, rect);
        //右
        rect = CGRectMake(XRetangleRight, YMinRetangle - 0.05, self.viewStyle.xScanRetangleOffset, sizeRetangle.height + 0.1);
        CGContextFillRect(context, rect);
        //下
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width, self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        
        CGContextStrokePath(context);
    }
    if (self.viewStyle.isNeedShowRetangle) {//画矩形框
        CGContextSetStrokeColorWithColor(context, self.viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(self.viewStyle.xScanRetangleOffset, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        CGContextStrokePath(context);
    }
    
    _scanRetangleRect = CGRectMake(self.viewStyle.xScanRetangleOffset, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    //画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = self.viewStyle.photoframeAngleW;
    int hAngle = self.viewStyle.photoframeAngleH;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = self.viewStyle.photoframeLineW;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    
    switch (_viewStyle.photoFrameAngleStyle)
    {
        case LEEScanViewPhotoFrameAngleStyle_Outer:
        {
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
        }
            break;
        case LEEScanViewPhotoFrameAngleStyle_On:
        {
            diffAngle = 0;
        }
            break;
        case LEEScanViewPhotoFrameAngleStyle_Inner:
        {
            diffAngle = -linewidthAngle/2;
            
        }
            break;
            
        default:
        {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    
    //
    CGFloat leftX = self.viewStyle.xScanRetangleOffset - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}

- (void)startScanAnimation {
    
    switch (self.viewStyle.animationStyle) {
        case LEEScanViewAnimationStyle_LineMove:
        {
            //线动画
            if (!_scanLineAnimation){
                self.scanLineAnimation = [[LEEScanLineAnimation alloc]init];
            }
            [_scanLineAnimation startAnimatingWithRect:_scanRetangleRect
                                                InView:self
                                                 Image:_viewStyle.animationImage];
        }
            break;
        case LEEScanViewAnimationStyle_NetGrid:
        {
            //网格动画
            if (!_scanNetAnimation)
                self.scanNetAnimation = [[LEEScanNetAnimation alloc]init];
            [_scanNetAnimation startAnimatingWithRect:_scanRetangleRect
                                               InView:self
                                                Image:_viewStyle.animationImage];
        }
            break;
        case LEEScanViewAnimationStyle_LineStill:
        {
            if (!_scanLineStill) {
                
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x+20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height/2,
                                              _scanRetangleRect.size.width-40,
                                              2);
                _scanLineStill = [[UIImageView alloc]initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
            break;
        default:
            break;
    }
}

- (void)stopScanAnimation {
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }
    
    if (_scanNetAnimation) {
        [_scanNetAnimation stopAnimating];
    }
    
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

@end
