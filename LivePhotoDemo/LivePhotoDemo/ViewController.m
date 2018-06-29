//
//  ViewController.m
//  LivePhotoDemo
//
//  Created by ljb48229 on 2018/2/23.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <PhotosUI/PhotosUI.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArr = [NSMutableArray array];
}
- (IBAction)openPhotoes:(id)sender {
    UIImagePickerController *imagePickVC = [[UIImagePickerController alloc] init];
    //    imagePickVC.allowsEditing = YES;
    imagePickVC.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];
    imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickVC.delegate = self;
    [self presentViewController:imagePickVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
//        PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
//        if (photo) {
//            PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
//            photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
//            photoView.contentMode = UIViewContentModeScaleAspectFill;
//            [self.view addSubview:photoView];
//        } else {
//            NSLog(@"普通图片,使用UIImageView加载即可");
//        }
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        PHAsset *asset = fetchResult.firstObject;
        [self getVideoFromPHAsset:asset Complete:^(NSData *data, NSString *fileName) {
/** 2018-02-24 15:41:54
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
            imageview.image = [self getVideoPreViewImage:fileName];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageview];
*/
            [self splitVideo:[NSURL fileURLWithPath:fileName] fps:15 completedBlock:^{
                
            }];
        }];
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void(^)(NSData *data, NSString *fileName))result {
    
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypeVideo || assetRes.type == PHAssetResourceTypePairedVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *path_Movie_File = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSLog(@"%@",path_Movie_File);
        NSLog(@"%@",NSHomeDirectory());
        [[NSFileManager defaultManager] removeItemAtPath:path_Movie_File error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:path_Movie_File] options:nil completionHandler:^(NSError * _Nullable error) {
            if (error) {
                result(nil, nil);
            } else {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path_Movie_File]];
                result(data, path_Movie_File);
            }
        }];
    }
}

//获取一帧图片
- (UIImage *)getVideoPreViewImage:(NSString *)fileName {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:fileName] options:nil];
    int second = (int)asset.duration.value / asset.duration.timescale; // 获取视频总时长,单位秒
    NSLog(@"movie duration : %lld", asset.duration.value); //1384
    NSLog(@"movie timescale : %d", asset.duration.timescale); //600
    NSLog(@"movie duration : %d", second); //2
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2, 600); //CMTimeMake(1384, 600); //0.0  600
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return img;
}

/**
 *  把视频文件拆成图片保存在沙盒中
 *
 *  @param fileUrl        本地视频文件URL
 *  @param fps            拆分时按此帧率进行拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(void))completedBlock {
    if (!fileUrl) {
        return;
    }
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSInteger timesCount = [times count];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        printf("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%lld.png",requestedTime.value]];
                [self.imgArr addObject:[UIImage imageWithCGImage:image]];
                NSData *imgData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                [imgData writeToFile:filePath atomically:YES];
                if (requestedTime.value == timesCount) {
                    NSLog(@"completed");
                    if (completedBlock) {
                        completedBlock();
                    }
                }
            }
                break;
        }
    }];
}



- (IBAction)makeMovAction:(id)sender {
    [self testCompressionSession];
}

-(void)testCompressionSession
{
    [self.imgArr addObject:[UIImage imageNamed:@"zhifubao"]];
    //设置mov路径
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *moviePath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"newMov"]];
//    self.theVideoPath=moviePath;
    
    //定义视频的大小320 480 倍数
    CGSize size =self.view.bounds.size;
    
    //        [selfwriteImages:imageArr ToMovieAtPath:moviePath withSize:sizeinDuration:4 byFPS:30];//第2中方法
    
    NSError *error =nil;
    //    转成UTF-8编码
    unlink([moviePath UTF8String]);
    NSLog(@"path->%@",moviePath);
    //     iphone提供了AVFoundation库来方便的操作多媒体设备，AVAssetWriter这个类可以方便的将图像和音频写成一个完整的视频文件
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath] fileType:AVFileTypeQuickTimeMovie error:&error];
    
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error =%@", [error localizedDescription]);
    //mov的格式设置 编码格式 宽度 高度
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput *writerInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
    //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
    //    是更有效的比添加像素缓冲区分配使用一个单独的池
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
    {
        NSLog(@"11111");
    }
    else
    {
        NSLog(@"22222");
    }
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        
        while([writerInput isReadyForMoreMediaData])
        {
            if(++frame >=[self.imgArr count])
            {
                [writerInput markAsFinished];
                [videoWriter finishWriting];
                //              [videoWriterfinishWritingWithCompletionHandler:nil];
                break;
            }
            CVPixelBufferRef buffer =NULL;
            int idx =frame;
            NSLog(@"idx==%d",idx);
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[self.imgArr objectAtIndex:idx] CGImage] size:size];
            
            if (buffer)
            {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,15)])//设置每秒钟播放图片的个数
                {
                    NSLog(@"FAIL");
                }
                else
                {
                    NSLog(@"OK");
                }
                
                CFRelease(buffer);
            }
        }
    }];
    
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status ==kCVReturnSuccess && pxbuffer !=NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata =CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    CGContextRef context =CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    // 释放色彩空间
    CGColorSpaceRelease(rgbColorSpace);
    // 释放context
    CGContextRelease(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}
@end























