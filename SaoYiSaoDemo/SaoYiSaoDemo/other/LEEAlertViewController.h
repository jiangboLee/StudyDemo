//
//  LEEAlertViewController.h
//  LEEAlertView
//
//  Created by 李江波 on 2017/6/11.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LEEAlertViewControllerHandler)(UIAlertAction * _Nullable action);
typedef void(^LEEAlertVCTextFieldHandler)(UITextField * _Nonnull textField);

@interface LEEAlertViewController : UIViewController

@property(nonatomic, assign) NSInteger destructiveIndex;
@property(nonatomic, assign) NSInteger CancleIndex;

+ (void)setDestructiveActionStyle:(NSInteger)index;
+ (void)setCancleActionStyle:(NSInteger)index;
#pragma make - Show Methods

/*Simple show */
+ (void)showWithTitle:(nullable NSString*)title message:(nullable NSString*)message; // default actionTitle is 确定,alertType is UIAlertControllerStyleAlert.
+ (void)showWithTitle:(nullable NSString*)title message:(nullable NSString*)message handle:(nullable LEEAlertViewControllerHandler)handle; // default actionTitle is 确定,alertType is UIAlertControllerStyleAlert.
+ (void)showWithTitle:(nullable NSString*)title message:(nullable NSString*)message alertType:(UIAlertControllerStyle)type; // default actionTitle is 确定.
+ (void)showWithTitle:(nullable NSString*)title message:(nullable NSString*)message alertType:(UIAlertControllerStyle)type handle:(nullable LEEAlertViewControllerHandler)handle;

/*More Actions*/
//warning: actionTitles and handles must One-to-one correspondence;if donot need handle ,you can write @""(NSString class all is ok) insert.
+ (void)showWithTitle:(nullable NSString*)title message:(nullable NSString*)message alertType:(UIAlertControllerStyle)type actionTitles:(nullable NSArray*)actionTitles handles:(nullable NSArray*)handles;

/*TextField*/
+ (void)showTextFieldWithTitle:(nullable NSString*)title message:(nullable NSString*)message actionTitles:(nullable NSArray*)actionTitles handles:(nullable NSArray*)handles textFieldHandles:(nullable NSArray <LEEAlertVCTextFieldHandler>*)textFieldHandles;

@end
