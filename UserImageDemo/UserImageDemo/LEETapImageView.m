//
//  LEETapImageView.m
//  UserImageDemo
//
//  Created by ljb48229 on 2018/1/12.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import "LEETapImageView.h"

@implementation LEETapImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressAction {
    NSLog(@"要保存吗？？？？？？？？？？？？");
}
@end
