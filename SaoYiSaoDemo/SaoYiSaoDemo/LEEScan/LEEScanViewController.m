//
//  LEEScanViewController.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanViewController.h"
#import "LEEAlertViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LEEScanView.h"
#import "LEEScanPhotoPermissions.h"
#import "LEEScanNative.h"
#import "LEEResultViewController.h"

@interface LEEScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property(nonatomic, strong) LEEScanView *scanView;
@property(nonatomic, strong) LEEScanNative *scanNative;

//底部显示的功能项
@property(nonatomic, strong) UIView *bottomItemsView;
//闪光灯
@property(nonatomic, strong) UIButton *btnFlash;
/**
 扫码区域上方提示文字
 */
@property(nonatomic, strong) UILabel *topTitle;

@property(nonatomic, assign) CGFloat lastScale;

@end

@implementation LEEScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"扫一扫";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(openPhotoesLib)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LEEScanPhotoPermissions requestCameraPemissionWithResult:^(BOOL granted) {

        if (granted) {
            [self startScan];
            [self drawScanView];
            [self drawTitle];
            [self drawBottomItems];
        } else {
            [LEEAlertViewController showWithTitle:@"提示" message:@"请到设置隐私中开启本程序相机权限"];
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_scanNative stopScan];
    [self.scanView stopScanAnimation];
    
}
//增加捏合手势，放大缩小镜头
- (void)addPinchGesture {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleGesture:)];
    self.lastScale = 1;
    [self.view addGestureRecognizer:pinch];
}

- (void)scaleGesture:(UIPinchGestureRecognizer *)sender {
    NSLog(@"%f",sender.scale);
    if (sender.state == UIGestureRecognizerStateBegan) {
        sender.scale = self.lastScale;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.lastScale = sender.scale;
    }
    [self.scanNative setVideoScale:sender.scale];
}

//绘制标题
- (void)drawTitle
{
    if (_topTitle == nil)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 150);
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}
//绘制下方功能键试图
- (void)drawBottomItems {
    if (_bottomItemsView != nil) {
        return;
    }
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164, self.view.bounds.size.width, 300)];
    self.bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:self.bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    _btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, 50);
    [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_scan_off"] forState:UIControlStateSelected];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomItemsView addSubview:_btnFlash];
}
//绘制扫描试图
- (void)drawScanView {
    if (_scanView == nil) {
        _scanView = [[LEEScanView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [self.view addSubview:self.scanView];
    }
}

- (void)startScan {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];
        if (_scanNative == nil) {
            
            _scanNative = [[LEEScanNative alloc] initWithPreView:videoView ObjectType:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code] cropRect:self.view.frame success:^(NSArray<NSString *> *array) {
                if (array.count > 0) {
                    
                    [self getResultAndDoSomething:array[0]];
                }
            }];
            [self addPinchGesture];
        }
        [_scanNative startScan];
        [self.scanView startScanAnimation];
    });
}

#pragma mark : - 打开相册
- (void)openPhotoesLib {
    if ([LEEScanPhotoPermissions photoPermission]) {
        [self openLocalPhoto];
    } else {
        [LEEAlertViewController showWithTitle:@"提示" message:@"请到设置->隐私中开启本程序相册权限"];
    }
}
- (void)openLocalPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [LEEScanNative recognizeImage:image success:^(NSArray *result) {
        for (int i = 0; i < result.count; i ++) {
            [self getResultAndDoSomething:result[i]];
        }
        if (result.count == 0) {
            [LEEAlertViewController showWithTitle:@"提示" message:@"未检测到有二维码哦"];
        }
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark : - 开关闪光灯
- (void)openOrCloseFlash:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    [_scanNative changeTorch];
}

- (void)getResultAndDoSomething:(NSString *)str {
    if ([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"]) {
        
        LEEResultViewController *resultVC = [[LEEResultViewController alloc] init];
        resultVC.urlStr = str;
        [self.navigationController pushViewController:resultVC animated:YES];
    } else {
        [LEEAlertViewController showWithTitle:@"ok" message:str handle:^(UIAlertAction * _Nullable action) {
            [self startScan];
        }];
    }
}





@end
