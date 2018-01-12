//
//  LEEAlertViewController.m
//  LEEAlertView
//
//  Created by 李江波 on 2017/6/11.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "LEEAlertViewController.h"

@interface LEEAlertViewController ()


@end

@implementation LEEAlertViewController
static LEEAlertViewController* leeAlertViewController;
+ (LEEAlertViewController *)share {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leeAlertViewController = [[LEEAlertViewController alloc]init];
        leeAlertViewController.CancleIndex = 1000;
        leeAlertViewController.destructiveIndex = 1000;
    });
    return leeAlertViewController;
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {

    [self showWithTitle:title message:message alertType:UIAlertControllerStyleAlert handle:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message handle:(LEEAlertViewControllerHandler)handle {

    [self showWithTitle:title message:message alertType:UIAlertControllerStyleAlert handle:handle];
}

+ (void)showWithTitle:(NSString *)title message:(nullable NSString *)message alertType:(UIAlertControllerStyle)type {

    [self showWithTitle:title message:message alertType:type handle:nil];
}

+ (void)showWithTitle:(NSString *)title message:(nullable NSString*)message alertType:(UIAlertControllerStyle)type handle:(LEEAlertViewControllerHandler)handle {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:type];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handle];
    [alertController addAction:action1];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message alertType:(UIAlertControllerStyle)type actionTitles:(NSArray *)actionTitles handles:(NSArray *)handles {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:type];
    for (int i = 0 ; i < actionTitles.count; i ++) {
        UIAlertAction *action;
        NSInteger style = [self share].destructiveIndex == i ? UIAlertActionStyleDestructive : UIAlertViewStyleDefault;
        style = ([self share].CancleIndex == i ? UIAlertActionStyleCancel : style);
        if ([handles[i] isKindOfClass:[NSString class]]) {
            
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:style handler:nil];
        } else {
        
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:style handler:handles[i]];
        }
        [alertController addAction:action];
    }
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showTextFieldWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles handles:(NSArray *)handles textFieldHandles:(nullable NSArray<LEEAlertVCTextFieldHandler>*)textFieldHandles{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (LEEAlertVCTextFieldHandler itemHandle in textFieldHandles) {
        [alertController addTextFieldWithConfigurationHandler:itemHandle];
    }
    for (int i = 0 ; i < actionTitles.count; i ++) {
        UIAlertAction *action;
        NSInteger style = [self share].destructiveIndex == i ? UIAlertActionStyleDestructive : UIAlertViewStyleDefault;
        style = ([self share].CancleIndex == i ? UIAlertActionStyleCancel : style);
        if ([handles[i] isKindOfClass:[NSString class]]) {
            
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:style handler:nil];
        } else {
            
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:style handler:handles[i]];
        }
        [alertController addAction:action];
    }
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Setters 

+ (void)setDestructiveActionStyle:(NSInteger)index {

    [self share].destructiveIndex = index;
    
}
+ (void)setCancleActionStyle:(NSInteger)index {

    [self share].CancleIndex = index;
}
#pragma mark - UIAppearance Setters

- (void)setDestructiveIndex:(NSInteger)Index {

    _destructiveIndex = Index;
}

- (void)setCancleIndex:(NSInteger)Index {

    _CancleIndex = Index;
}
@end







