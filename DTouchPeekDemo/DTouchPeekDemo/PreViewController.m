//
//  PreViewController.m
//  DTouchPeekDemo
//
//  Created by ljb48229 on 2017/12/26.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "PreViewController.h"

@interface PreViewController ()

@property (weak, nonatomic) IBOutlet UILabel *forceLable;
@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(1000)/1000.0 green:arc4random_uniform(1000)/1000.0 blue:arc4random_uniform(1000)/1000.0 alpha:1];
    
    self.lable.text = _text;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"action1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action1");
    }];
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action2");
    }];
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"action3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action3");
    }];
    return @[action1,action2,action3];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches allObjects].lastObject;
    self.forceLable.text = [NSString stringWithFormat:@"压力%f",touch.force];
}

@end
