//
//  LEETapImageView.m
//  UserImageDemo
//
//  Created by ljb48229 on 2018/1/12.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import "LEETapImageView.h"
#import <Photos/Photos.h>

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
    
    UIImage *img = self.image;
    [LEEAlertViewController showWithTitle:nil message:nil alertType:UIAlertControllerStyleActionSheet actionTitles:@[@"保存图片", @"取消"] handles:@[^(UIAlertAction * _Nullable action) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:img];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"保存成功");
            } else {
                NSLog(@"%@",error);
            }
        }];
    }, ^(UIAlertAction * _Nullable action) {
        
    }]];
}
@end
