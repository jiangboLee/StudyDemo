//
//  LEEUserIconViewController.m
//  UserImageDemo
//
//  Created by ljb48229 on 2018/1/12.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import "LEEUserIconViewController.h"
#import "LEEScrollView.h"



@interface LEEUserIconViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIImageView *userIcon;
@property (strong, nonatomic) LEEScrollView *scrollView;

@end

@implementation LEEUserIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.scrollView = [[LEEScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.img = self.icon;
    [self.view addSubview:self.scrollView];
    //添加手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
}
//双击
- (void)doubleTapAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    [self.scrollView handleDoubleTap:point];
   
/** 2018-01-12 17:27:38
    [UIView animateWithDuration:0.8 animations:^{

        if (self.scrollView.contentSize.width > SCREEN_W) {
            self.scrollView.frame = CGRectMake(0, (SCREEN_H - SCREEN_W) / 2, SCREEN_W, SCREEN_W);
            self.scrollView.contentSize = CGSizeMake(SCREEN_W, SCREEN_W);
            self.userIcon.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W);
        } else {
            self.scrollView.contentSize = CGSizeMake(SCREEN_W * 2, SCREEN_H);
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            self.userIcon.frame = CGRectMake(0, 0, SCREEN_W * 2, SCREEN_H);
            CGPoint point = [tapGestureRecognizer locationInView:self.scrollView];
            if (point.x > SCREEN_W / 2) {
                [self.scrollView setContentOffset:CGPointMake(SCREEN_W, 0) animated:NO];
            }
        }
    }];
*/
}

- (IBAction)showAlertViewAction:(id)sender {
    
}




@end
