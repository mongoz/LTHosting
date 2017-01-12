//
//  eventCamera.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@protocol eventCameraDelegate


@end

@interface eventCamera : NSObject <AVCapturePhotoCaptureDelegate>

@property (readwrite, nonatomic) AVCaptureDevicePosition captureDevicePosition;
@property (readonly, strong, nonatomic) NSString *preset;
@property (readonly, strong, nonatomic) AVCaptureDevice *captureDevice;
@property (readonly, nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (readwrite, nonatomic) AVCaptureFlashMode captureFlashMode;

+(eventCamera*)sharedInstance;

-(void)startRunning;

-(void)stopRunning;

-(BOOL)isRunning;

-(BOOL)isPaused;

-(CGSize)size;

-(CGFloat)aspectRatio;

-(void)captureStillCMSampleBuffer:(void(^)(CMSampleBufferRef sampleBuffer, NSError *error))inCompletionBlock;

-(void)captureStillCVImageBuffer:(void(^)(CVImageBufferRef sampleBuffer, NSError *error))inCompletionBlock;

-(void)captureStillCIImage:(void(^)(CIImage *image, NSError *error))inCompletionBlock;

-(void)captureStillCGImage:(void(^)(CGImageRef image, NSError *error))inCompletionBlock;

-(void)captureStillUIImage:(void(^)(UIImage *image, NSError *error))inCompletionBlock;

-(void)switchCamera;

-(void)previewLayerTappedAtPoint:(CGPoint)point;

-(void)scaleZoomBy:(CGFloat)scale;

@end
