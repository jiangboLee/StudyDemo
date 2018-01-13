//
//  LEEScrollView.h
//  UserImageDemo
//
//  Created by ljb48229 on 2018/1/12.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEETapImageView.h"

@interface LEEScrollView : UIScrollView

@property (nonatomic , strong) UIImage *img;
@property(nonatomic, strong) LEETapImageView *imageView;

- (void)handleDoubleTap:(CGPoint)touchPoint;
@end

