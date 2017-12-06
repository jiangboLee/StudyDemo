//
//  LEEScanNative.m
//  SaoYiSaoDemo
//
//  Created by 李江波 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEScanNative.h"
#import <AVFoundation/AVFoundation.h>
#import "LEEAlertViewController.h"

@interface LEEScanNative()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput *deviceInput;
/**
 *  扫码结果返回
 */
@property(nonatomic,copy) void (^blockScanResult)(NSArray<NSString*> *array);

/**
 拍照
 */
@property(nonatomic,strong)  AVCaptureStillImageOutput *stillImageOutput;
/**
 视频预览显示视图
 */
@property(nonatomic,weak) UIView *videoPreView;
@end

@implementation LEEScanNative

- (instancetype)initWithPreView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void (^)(NSArray<NSString *> *))block {
    if (self = [super init]) {
        [self initParaWithPreView:preView ObjectType:objType cropRect:cropRect success:block];
    }
    return self;
}

- (void)initParaWithPreView:(UIView*)videoPreView ObjectType:(NSArray*)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<NSString*> *array))block {
    
    self.blockScanResult = block;
    self.videoPreView = videoPreView;
    
    _session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (_deviceInput) {
        
        [_session addInput:_deviceInput];
        
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:metadataOutput];
        metadataOutput.metadataObjectTypes = objType;
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [_stillImageOutput setOutputSettings:outputSettings];
        [_session addOutput:_stillImageOutput];
        
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = cropRect;
        [videoPreView.layer insertSublayer:previewLayer atIndex:0];
        
    
        //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
        if (_deviceInput.device.isFocusPointOfInterestSupported && [_deviceInput.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [_deviceInput.device lockForConfiguration:nil];
            [_deviceInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [_deviceInput.device unlockForConfiguration];
        }
    } else {
        [LEEAlertViewController showWithTitle:@"错误" message:[NSString stringWithFormat:@"%@",error]];
    }
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        [self stopScan];
        self.blockScanResult(@[metadataObject.stringValue]);
    }
    
}

- (void)startScan {
    if (_session != nil && !_session.isRunning) {
        [_session startRunning];
    }
}

- (void)stopScan {
    if (_session != nil && _session.isRunning) {
        [_session stopRunning];
    }
}
//开关闪光灯
- (void)changeTorch {
    AVCaptureTorchMode torch = _deviceInput.device.torchMode;
    switch (torch) {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    [_deviceInput.device lockForConfiguration:nil];
    _deviceInput.device.torchMode = torch;
    [_deviceInput.device unlockForConfiguration];
}
//设置镜头缩放
- (void)setVideoScale:(CGFloat)scale {
    //一开始系统默认是1
    [_deviceInput.device lockForConfiguration:nil];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:self.stillImageOutput.connections];
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    //videoScaleAndCropFactor cannot be set to a value less than 1.0
    if (scale >= 1) {
        
        videoConnection.videoScaleAndCropFactor = scale;
    }
    [_deviceInput.device unlockForConfiguration];
    if (scale >= 1) {
        
        CGAffineTransform transform = self.videoPreView.transform;
        self.videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
    }
    
    
}
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([port.mediaType isEqual:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

+ (void)recognizeImage:(UIImage *)image success:(void(^)(NSArray *))block {
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray *mutableStr = [NSMutableArray array];
    for (int i = 0; i < features.count; i ++) {
        CIQRCodeFeature *feature = features[i];
        NSString *scannedResult = feature.messageString;
        [mutableStr addObject:scannedResult];
    }
    block(mutableStr.copy);
}
@end
