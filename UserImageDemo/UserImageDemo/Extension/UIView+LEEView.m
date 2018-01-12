//
//  UIView+LEEView.m
//  LEEAddition
//
//  Created by 李江波 on 2017/6/17.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "UIView+LEEView.h"

@implementation UIView (LEEView)

- (void)setLee_X:(CGFloat)Lee_X {

    CGRect rect = self.frame;
    rect.origin.x = Lee_X;
    self.frame = rect;
}
- (void)setLee_Y:(CGFloat)Lee_Y {

    CGRect rect = self.frame;
    rect.origin.y = Lee_Y;
    self.frame = rect;
}
- (void)setLee_Width:(CGFloat)Lee_Width {

    CGRect rect = self.frame;
    rect.size.width = Lee_Width;
    self.frame = rect;
}
- (void)setLee_Height:(CGFloat)Lee_Height {

    CGRect rect = self.frame;
    rect.size.height = Lee_Height;
    self.frame = rect;
}
- (void)setLee_CenterX:(CGFloat)Lee_CenterX {

    CGPoint point = self.center;
    point.x = Lee_CenterX;
    self.center = point;
}
- (void)setLee_CenterY:(CGFloat)Lee_CenterY {

    CGPoint point = self.center;
    point.y = Lee_CenterY;
    self.center = point;
}
- (void)setLee_Size:(CGSize)Lee_Size {

    CGRect rect = self.frame;
    rect.size = Lee_Size;
    self.frame = rect;
}
- (CGFloat)Lee_X {

    return self.frame.origin.x;
}
- (CGFloat)Lee_Y {

    return self.frame.origin.y;
}
- (CGFloat)Lee_CenterX {

    return self.center.x;
}
- (CGFloat)Lee_CenterY {

    return self.center.y;
}
- (CGFloat)Lee_Width {

    return self.frame.size.width;
}
- (CGFloat)Lee_Height {

    return self.frame.size.height;
}
- (CGSize)Lee_Size {

    return self.frame.size;
}

- (void)setBorderWidth:(CGFloat)borderWidth {

    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}
- (void)setBorderColor:(UIColor *)borderColor {

    self.layer.borderColor = borderColor.CGColor;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {

    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}
- (void)setLee_hasShadown:(BOOL)lee_hasShadown {

    if (lee_hasShadown) {
        self.layer.shadowRadius = 1;
//        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSizeMake(0, 0.5);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
}
- (BOOL)lee_hasShadown {

    return YES;
}
- (CGFloat)borderWidth {

    return self.layer.borderWidth;
}
- (UIColor *)borderColor {

    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (CGFloat)cornerRadius {

    return self.layer.cornerRadius;
}

- (UIImage *)lee_snapshotImage {
    /*
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
     */
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *bgColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGRect bgRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGContextAddRect(context, bgRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else
    {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
   
    
   
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end






