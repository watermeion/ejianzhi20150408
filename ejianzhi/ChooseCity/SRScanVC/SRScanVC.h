//
//  SRScanVC.h
//  DaZhe
//
//  Created by RAY on 14-11-8.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol finishScaning <NSObject>
@required
- (void)finishScaning:(NSString *)QRCode;
@end

@interface SRScanVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property (strong,nonatomic) id<finishScaning>scanDelegate;

@end
