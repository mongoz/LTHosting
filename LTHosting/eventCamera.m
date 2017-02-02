//
//  eventCamera.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventCamera.h"

@interface eventCamera(){
    BOOL isCaptured;
    CMSampleBufferRef sampleBuffer;
    NSError *captureError;
}
    @property (readwrite, nonatomic, strong) AVCaptureSession *captureSession;
    @property (readwrite, nonatomic, strong) AVCaptureDevice *captureDevice;
    @property (readwrite, nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
    @property (readwrite, nonatomic, strong) AVCapturePhotoOutput *photoOutput;
@end

@implementation eventCamera

+(eventCamera*)sharedInstance
{
    static eventCamera *sharedCamera=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCamera=[[self alloc] init];
    });
    return sharedCamera;
}

-(id)init
{
    if(self=[super init])
    {
        _captureDevicePosition=AVCaptureDevicePositionUnspecified;
        _preset=AVCaptureSessionPresetPhoto;
        _captureFlashMode=AVCaptureFlashModeOff;
        isCaptured=NO;
    }
    return self;
}

-(void)dealloc
{
    [_captureSession stopRunning];
}

-(BOOL)isRunning
{
    return [_captureSession isRunning];
}

-(BOOL)isPaused
{
    return ![_previewLayer.connection isEnabled];
}

-(AVCaptureDevice*)captureDevice
{
    if(_captureDevice==NULL)
    {
        if(self.captureDevicePosition==AVCaptureDevicePositionUnspecified)
        {
            _captureDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        else
        {
            AVCaptureDeviceDiscoverySession *sesh=[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:[NSArray arrayWithObjects:AVCaptureDeviceTypeBuiltInTelephotoCamera, AVCaptureDeviceTypeBuiltInWideAngleCamera, nil] mediaType:AVMediaTypeVideo position:_captureDevicePosition];
            _captureDevice=[[sesh devices] firstObject];
            
        }
    }
    return  _captureDevice;
}

-(AVCaptureVideoPreviewLayer*)previewLayer
{
    if(_previewLayer==NULL)
    {
        _previewLayer=[AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        _previewLayer.videoGravity=AVLayerVideoGravityResizeAspect;
        _previewLayer.connection.videoOrientation=AVCaptureVideoOrientationPortrait;
        [_previewLayer setMasksToBounds:YES];
        
    }
    return _previewLayer;
}

-(void)updateCaptureDevicePosition:(AVCaptureDevicePosition)position
{
    _captureDevicePosition=position;
}

-(void)startRunning
{
    NSError *error=NULL;
    
    _captureDevice=[self captureDevice];
    [_captureDevice lockForConfiguration:nil];
    if([_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        [_captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if([_captureDevice isSmoothAutoFocusEnabled])
    {
        [_captureDevice setSmoothAutoFocusEnabled:YES];
    }
    if([_captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose])
    {
        [_captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    [_captureDevice unlockForConfiguration];
    
    _captureSession=[[AVCaptureSession alloc] init];
    _captureSession.sessionPreset=_preset;
    
    AVCaptureDeviceInput *capDeviceInput=[AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    [_captureSession addInput:capDeviceInput];
    
    _photoOutput=[[AVCapturePhotoOutput alloc] init];
    AVCaptureConnection *connection=[_photoOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    [_captureSession addOutput:_photoOutput];
    _previewLayer=[self previewLayer];
    [_captureSession startRunning];
}

-(void)stopRunning
{
    [self.captureSession stopRunning];
    _captureDevice=NULL;
    _captureSession=NULL;
    _photoOutput=NULL;
    _previewLayer=NULL;
}

-(CGSize)size
{
    
    id previewPixelType=_photoOutput.availablePhotoPixelFormatTypes[0];
    AVCapturePhotoSettings *capture=[AVCapturePhotoSettings photoSettingsWithFormat:[NSDictionary dictionaryWithObject:previewPixelType forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey]];
    [_photoOutput capturePhotoWithSettings:capture delegate:self];
    while(!isCaptured)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    }
    isCaptured=NO;
    CVImageBufferRef imageBuffer=CMSampleBufferGetImageBuffer(sampleBuffer);
    return CVImageBufferGetEncodedSize(imageBuffer);
}

-(CGFloat)aspectRatio
{
    CGSize size=CMVideoFormatDescriptionGetPresentationDimensions(_captureDevice.activeFormat.formatDescription, YES, YES);
    CGFloat aspectRatio=size.width/size.height;
    return aspectRatio;
}

-(void)captureStillCMSampleBuffer:(void (^)(CMSampleBufferRef, NSError *))inCompletionBlock
{
    NSParameterAssert(inCompletionBlock!=NULL);
    id previewPixelType=_photoOutput.availablePhotoPixelFormatTypes[0];
    AVCapturePhotoSettings *capture=[AVCapturePhotoSettings photoSettingsWithFormat:[NSDictionary dictionaryWithObject:previewPixelType forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey]];
    [capture setFlashMode:_captureFlashMode];
    [_photoOutput capturePhotoWithSettings:capture delegate:self];
    while(!isCaptured)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    isCaptured=NO;
    [self stopRunning];
    if(captureError)
    {
        NSLog(@"captureError");
    }
    inCompletionBlock(sampleBuffer,captureError);
}

-(void)captureStillCVImageBuffer:(void (^)(CVImageBufferRef, NSError *))inCompletionBlock
{
    NSParameterAssert(inCompletionBlock!=NULL);
    [self captureStillCMSampleBuffer:^(CMSampleBufferRef bufferRef, NSError *error){
        CVImageBufferRef ref=NULL;
        if(bufferRef!=NULL)
        {
            ref=CMSampleBufferGetImageBuffer(bufferRef);
        }
        inCompletionBlock(ref,captureError);
    }];
}

-(void)captureStillCIImage:(void (^)(CIImage *image, NSError *))inCompletionBlock
{
    NSParameterAssert(inCompletionBlock!=NULL);
    [self captureStillCVImageBuffer:^(CVImageBufferRef imageBuffer, NSError *error){
        CIImage *image=NULL;
        if(imageBuffer!=NULL)
        {
            image=[CIImage imageWithCVImageBuffer:imageBuffer];
        }
        inCompletionBlock(image, error);
    }];
}

-(void)captureStillCGImage:(void (^)(CGImageRef, NSError *))inCompletionBlock
{
    NSParameterAssert(inCompletionBlock!=NULL);
    
    [self captureStillCIImage:^(CIImage *image, NSError *error){
        CGImageRef theCGImage=NULL;
        if(image!=NULL)
        {
            NSDictionary *options=@{
                                    
                                    };
            CIContext *context=[CIContext contextWithOptions:options];
            theCGImage=[context createCGImage:image fromRect:image.extent];
        }
        CGSize size=CGSizeMake(CGImageGetWidth(theCGImage), CGImageGetHeight(theCGImage));
        theCGImage=CGImageCreateWithImageInRect(theCGImage, CGRectMake(0, size.height/2-(size.width*836/750)/2, size.width, size.width*(836/750)));
        inCompletionBlock(theCGImage, error);
        CGImageRelease(theCGImage);
    }];
}

-(void)captureStillUIImage:(void (^)(UIImage *, NSError *))inCompletionBlock
{
    NSParameterAssert(inCompletionBlock!=NULL);
    [self captureStillCGImage:^(CGImageRef image, NSError *error){
        UIImage *theImage=NULL;
        if(image!=NULL)
        {
            if(_captureDevicePosition==AVCaptureDevicePositionFront)
            {
                theImage=[UIImage imageWithCGImage:image scale:1.0f orientation:UIImageOrientationLeftMirrored];
            }
            else
            {
                theImage=[UIImage imageWithCGImage:image scale:1.0f orientation:UIImageOrientationRight];
            }
        }
        inCompletionBlock(theImage,error);
    }];
}

-(UIImage*)flipImageHorizontally:(UIImage*)original
{
    UIImage *flippedImage;
    CGSize imageSize=original.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, 0);
    CGContextTranslateCTM(ctx, 0, -imageSize.width);
    CGContextDrawImage(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height), original.CGImage);
    flippedImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return flippedImage;
}

//AVCapturePhotoCaptureDelegate Methods

-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{
    CMSampleBufferCreateCopy(kCFAllocatorDefault, photoSampleBuffer, &sampleBuffer);
    captureError=error;
    isCaptured=YES;
}

//Method to change from front to back camera
-(void)switchCamera
{
    [_captureSession beginConfiguration];
    if(_captureDevicePosition==AVCaptureDevicePositionFront)
    {
        [self updateCaptureDevicePosition:AVCaptureDevicePositionBack];
    }
    else
    {
        [self updateCaptureDevicePosition:AVCaptureDevicePositionFront];
    }
    [_captureSession commitConfiguration];
}

//Method to autofocus the screen when a user taps it
-(void)previewLayerTappedAtPoint:(CGPoint)point
{
    if((![self isRunning])||[self isPaused])
    {
        return;
    }
    [_captureDevice lockForConfiguration:nil];
    CGPoint updated=[_previewLayer captureDevicePointOfInterestForPoint:point];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if([_captureDevice isFocusPointOfInterestSupported])
        {
            [_captureDevice setFocusPointOfInterest:updated];
            [_captureDevice setExposurePointOfInterest:updated];
            
        }
        if([_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [_captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if([_captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose])
        {
            [_captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        [_captureDevice unlockForConfiguration];
    }];
}

//Method to zoom when user pinches screen
-(void)scaleZoomBy:(CGFloat)scale
{
    if((![self isRunning])||[self isPaused]||(_captureDevice.videoZoomFactor*scale<1))
    {
        return;
    }
    [_captureDevice lockForConfiguration:nil];
    [_captureDevice setVideoZoomFactor:_captureDevice.videoZoomFactor*scale];
    [_captureDevice unlockForConfiguration];
}

@end
