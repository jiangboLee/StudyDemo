//
//  LEEScanLineAnimation.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanLineAnimation.h"

@interface LEEScanLineAnimation()

@property(nonatomic,assign) CGRect animationRect;
@property(nonatomic,assign) BOOL isAnimationing;
@end

@implementation LEEScanLineAnimation

- (void)stepAnimation
{
    if (!_isAnimationing) {
        return;
    }
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
        
    } completion:^(BOOL finished)
     {
         self.hidden = YES;
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage*)image {
    if (self.isAnimationing) {
        return;
    }
    self.isAnimationing = YES;
    self.animationRect = animationRect;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery, width, 2);
    self.image = image;
    [parentView addSubview:self];
    
    [self startAnimating_UIViewAnimation];
}

- (void)startAnimating_UIViewAnimation
{
    [self stepAnimation];
}

- (void)dealloc {
    [self stopAnimating];
}
- (void)stopAnimating {
    if (self.isAnimationing) {
        self.isAnimationing = NO;
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
