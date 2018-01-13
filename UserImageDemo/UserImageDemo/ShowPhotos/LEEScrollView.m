//
//  LEEScrollView.m
//  UserImageDemo
//
//  Created by ljb48229 on 2018/1/12.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import "LEEScrollView.h"

@interface LEEScrollView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end


static CGFloat scrollViewMinZoomScale = 1.0;
static CGFloat scrollViewMaxZoomScale = 3.0;
@implementation LEEScrollView

- (LEETapImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[LEETapImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //减速速率
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.panGestureRecognizer.delegate = self;
        self.minimumZoomScale = scrollViewMinZoomScale;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self imageView];
    }
    return self;
}

- (void)setImg:(UIImage *)img {
    _img = img;
    [self.imageView.layer removeAnimationForKey:@"llb.fade"];
    [self resetScrollViewStatusWithImage:img];
    self.imageView.image = img;
    self.maximumZoomScale = scrollViewMaxZoomScale;

    self.zoomScale = 1.0;
    self.contentOffset = CGPointMake(0, 0);
}
- (void)resetScrollViewStatusWithImage:(UIImage *)image {
    self.zoomScale = scrollViewMinZoomScale;
    self.imageView.frame = CGRectMake(0, (self.Lee_Height - self.Lee_Width) / 2, self.Lee_Width, self.Lee_Width);
/** 2018-01-12 19:05:44
    if (image.size.height / image.size.width > self.Lee_Height / self.Lee_Width) {
        self.imageView.Lee_Height = floor(image.size.height / (image.size.width / self.Lee_Width));
    }else {
        CGFloat height = image.size.height / image.size.width * self.Lee_Width;;
        self.imageView.Lee_Height = floor(height);
        self.imageView.Lee_CenterY = self.Lee_Height / 2 - 100;
    }
    if (self.imageView.Lee_Height > self.Lee_Height && self.imageView.Lee_Height - self.Lee_Height <= 1) {
        self.imageView.Lee_Height = self.Lee_Height;
    }
*/
    self.contentSize = CGSizeMake(self.Lee_Width, MAX(self.imageView.Lee_Height, self.Lee_Height));
    [self setContentOffset:CGPointZero];
    self.alwaysBounceVertical = NO;
    
    if (self.imageView.contentMode != UIViewContentModeScaleToFill) {
        self.imageView.contentMode =  UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter =  self.imageView.frame;
    // Horizontally floor：如果参数是小数，则求最大的整数但不大于本身.
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }

    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    // Center
    if (!CGRectEqualToRect( self.imageView.frame, frameToCenter)){
        self.imageView.frame = frameToCenter;
    }

}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    if (self.maximumZoomScale == self.minimumZoomScale) {
        return;
    }
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat newZoomScale = [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
        CGFloat xsize = self.Lee_Width / newZoomScale;
        CGFloat ysize = self.Lee_Height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (scrollView.minimumZoomScale != scale) return;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}




@end









