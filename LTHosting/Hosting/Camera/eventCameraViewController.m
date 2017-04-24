//
//  ViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventCameraViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "cblock.h"

@interface eventCameraViewController () {
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    
    CGFloat pinchStartScale;
    
    UIImageView *imagePreviewView;
    
    BOOL visible;
}
@end

@implementation eventCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[cblock make:^id{
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chevron Left-50"] style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
        CGFloat cushion=8.0f;
        CGFloat right=24.0f;
        [item setImageInsets:UIEdgeInsetsMake(cushion, cushion-right, cushion, cushion+right)];
        return item;
    }]];
    
    
    [self configureView];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Add tap recognizer to view
    UITapGestureRecognizer *screenTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [screenTap setDelegate:self];
    [_imageView addGestureRecognizer:screenTap];
    
    //Add pinch recognizer to view
    UIPinchGestureRecognizer *screenPinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPinched:)];
    [screenPinch setDelegate:self];
    [_imageView addGestureRecognizer:screenPinch];
    pinchStartScale=0;
    
    //Add tap gesture to libary bar
    [_libraryBarImageView addTarget:self action:@selector(libraryBarTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_libraryBarImageView setUserInteractionEnabled:YES];
    _libraryBarImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    _libraryBarImageView.layer.borderWidth=1.0f;
    _libraryBarImageView.layer.cornerRadius=2.0f;
    [_libraryBarImageView.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_libraryBar setBackgroundColor:[UIColor blackColor]];
    [_libraryBar sendSubviewToBack:_libraryBarImageView];
    
    
    
    //Disable good and bad photo buttons until photo is taken
    [self hideGoodBadButtons];
    
    //Set most recent image in libary bar
    [self findMostRecentImage];
    
    
    [_captureButton setContentMode:UIViewContentModeScaleAspectFit];
    [_captureButton.layer setShadowOpacity:0.0f];
    [_captureButton setTintColor:[UIColor flatWhiteColor]];
    CGFloat height=_libraryBar.frame.size.height-8*2;
    
    CALayer *mask=[CALayer layer];
    [mask setFrame:_captureButton.bounds];
    [mask setContents:(id)[UIImage imageNamed:@"CameraButton.png"].CGImage];
    [mask setContentsGravity:kCAGravityResizeAspect];
    [_captureButton.layer setMask:mask];
    [_captureButton.layer setBackgroundColor:[UIColor flatWhiteColor].CGColor];
    [_captureButton setTitle:@"" forState:UIControlStateNormal];
    
    CGFloat num=16;
    height=_libraryBar.frame.size.height-num*2;
    
    num*=1.5;
    height=_libraryBar.frame.size.height-num*2;
    [_switchCameraButton setTitle:@"" forState:UIControlStateNormal];
    UIImage *switchC=[UIImage imageNamed:@"SwitchCamera.png"];
    [_switchCameraButton setImage:[switchC imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_switchCameraButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_switchCameraButton setTintColor:[UIColor whiteColor]];
    CGFloat margin=8.0f;
    [_switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(margin, margin, margin, margin)];
    
    
    [_badPictureButton setImage:[[UIImage imageNamed:@"Poor Quality-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_badPictureButton setBackgroundColor:[UIColor flatWhiteColor]];
    [_badPictureButton.layer setShadowOpacity:0];
    
    [_goodPictureButton setImage:[[UIImage imageNamed:@"Good Quality-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_goodPictureButton setBackgroundColor:[UIColor flatWhiteColor]];
    [_goodPictureButton.layer setShadowOpacity:0];
    
}

-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];self.view.translatesAutoresizingMaskIntoConstraints=YES;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    visible=YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    visible=NO;
}

-(void)findMostRecentImage
{
    PHFetchResult *allPhotos=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSDate *maxCreationDate=[NSDate distantPast];
    PHAsset *newestAsset=nil;
    PHImageManager *manager=[PHImageManager defaultManager];
    for(PHAsset *image in allPhotos)
    {
        if([image.creationDate timeIntervalSinceDate:maxCreationDate]>0)
        {
            newestAsset=[image copy];
            maxCreationDate=newestAsset.creationDate;
        }
    }
    [manager requestImageForAsset:newestAsset targetSize:_imageView.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *retrieved, NSDictionary *info){
        if([info objectForKey:PHImageErrorKey])
        {
            NSLog(@"error retrieving photo");
        }
        [_libraryBarImageView setImage:retrieved forState:UIControlStateNormal];
        [_libraryBarImageView setBackgroundColor:[UIColor blackColor]];
    }];
}

-(IBAction)libraryBarTapped:(UIButton*)button
{
    [self hideCameraButtons];
    UIImagePickerController *pickerController=[[UIImagePickerController alloc] init];
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickerController setDelegate:self];
    [self presentViewController:pickerController animated:YES completion:^{
        [self showCameraButtons];
    }];
}

-(IBAction)imageViewTapped:(UITapGestureRecognizer *)tap
{
    CGFloat increment=(_imageView.frame.size.height-videoPreviewLayer.frame.size.height)/2;
    CGPoint adjusted=[tap locationInView:_imageView];
    adjusted.y+=increment;
    [[eventCamera sharedInstance] previewLayerTappedAtPoint:adjusted];
}

-(IBAction)imageViewPinched:(UIPinchGestureRecognizer *)pinch
{
    if(UIGestureRecognizerStateEnded==[pinch state])
    {
        pinchStartScale=0;
    }
    else if(pinchStartScale==0)
    {
        pinchStartScale=pinch.scale;
    }
    else
    {
        [[eventCamera sharedInstance] scaleZoomBy:pinch.scale/pinchStartScale];
        pinchStartScale=pinch.scale;
    }
}

-(void)configureView
{
    [self addCameraView];
    [self setUpShadowForButton:_captureButton];
    [self setUpShadowForButton:_switchCameraButton];
    [self setUpShadowForButton:_goodPictureButton];
    [self setUpShadowForButton:_badPictureButton];
    [self setUpShadowForButton:_flashButton];
}

-(void)setUpShadowForButton:(UIButton*)button
{
    [button.layer setOpaque:YES];
    [button.layer setCornerRadius:10];
    [button.layer setMasksToBounds:NO];
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:1.0f];
    [button.layer setShadowRadius:8];
    [button.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Handle segue
-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self removeCameraView];
    [super performSegueWithIdentifier:identifier sender:sender];
}


- (IBAction)switchCameraView:(id)sender {
    [_switchCameraButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.1 animations:^{
        [_switchCameraButton setAlpha:.5f];
    } completion:^(BOOL finished){
        [eventCamera sharedInstance].captureFlashMode=AVCaptureFlashModeOff;
        [self updateFlashButtonText];
        if([eventCamera sharedInstance].captureDevicePosition==AVCaptureDevicePositionFront)
        {
            _flashButton.userInteractionEnabled=NO;
        }
        else
        {
            _flashButton.userInteractionEnabled=YES;
        }
        [self removeCameraView];
        [[eventCamera sharedInstance] switchCamera];
        [self addCameraView];
        [UIView animateWithDuration:.25 animations:^{
            [_switchCameraButton setAlpha:1.0f];
        } completion:^(BOOL finished){
            [_switchCameraButton setUserInteractionEnabled:YES];
        }];
        
    }];
}

- (IBAction)capturePhoto:(id)sender {
    [self hideCameraButtons];
    [[eventCamera sharedInstance] captureStillUIImage:^(UIImage *image, NSError *error){
        
        if(error)
        {
            NSLog(@"error capturing photo");
        }
        imagePreviewView=[[UIImageView alloc] initWithImage:image];
        [imagePreviewView setAutoresizesSubviews:YES];
        [imagePreviewView setContentMode:UIViewContentModeScaleAspectFit];
        //[imagePreviewView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        imagePreviewView.frame=_imageView.bounds;
        [self removeCameraView];
        [_imageView addSubview:imagePreviewView];
        [_imageView sendSubviewToBack:imagePreviewView];
        [self showGoodBadButtons];
    }];
}

-(void)addPhotoToSavedPhotos:(UIImage*)photo
{
    __block PHFetchResult *photoAsset;
    __block PHAssetCollection *myCollection=[self getAPPCollection];
    __block PHObjectPlaceholder *placeholder;
    UIImage *newImage=[UIImage imageWithCGImage:photo.CGImage];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //Perform changes to photo library
        NSLog(@"2: %@",myCollection.localizedTitle);
        PHAssetChangeRequest *req=[PHAssetChangeRequest creationRequestForAssetFromImage:newImage];
        placeholder=[req placeholderForCreatedAsset];
        photoAsset=[PHAsset fetchAssetsInAssetCollection:myCollection options:nil];
        PHAssetCollectionChangeRequest *albumChange=[PHAssetCollectionChangeRequest changeRequestForAssetCollection:myCollection assets:photoAsset];
        //[libReq addAssets:@[assetPlaceHolder]];
    }completionHandler:^(BOOL success, NSError *error){
        //Perform any necessary actions after adding the photo to the photo library
        if(!success)
        {
            NSLog(@"didn't succeed, error: %@",error.localizedDescription);
        }
    }];
}

- (PHAssetCollection *)getAPPCollection {
    //Checking to see if album already exists
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSString *appName = @"LocalThunder";
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:appName]) {
            return collection;
        }
    }
    
    //If not, creating the blum
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        NSLog(@"error");
        return nil;
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

//Methods to add and remove camera view
-(void)addCameraView
{
    if(![[eventCamera sharedInstance] isRunning])
    {
        [[eventCamera sharedInstance] startRunning];
    }
    [[[eventCamera sharedInstance] previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspect];
    [[[eventCamera sharedInstance] previewLayer] setFrame:_imageView.bounds];
    videoPreviewLayer=[[eventCamera sharedInstance] previewLayer];
    [_imageView.layer insertSublayer:videoPreviewLayer atIndex:0];
    //CGFloat ratio=[[eventCamera sharedInstance] aspectRatio];
    //[videoPreviewLayer setFrame:CGRectMake(0, _imageView.bounds.origin.y, videoPreviewLayer.frame.size.width, videoPreviewLayer.frame.size.width*ratio)];
    [videoPreviewLayer setFrame:_imageView.bounds];
    [self updateFlashButtonText];
}

-(void)updateFlashButtonText;
{
    AVCaptureFlashMode flashMode=[[eventCamera sharedInstance] captureFlashMode];
    NSString *text=@"Off";
    if(flashMode==AVCaptureFlashModeOn)
    {
        text=@"On";
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_flashButton setEnabled:NO];
        [_flashButton setTitle:text forState:UIControlStateNormal];
        [_flashButton setEnabled:YES];
    }];
}

-(void)removeCameraView
{
    [videoPreviewLayer removeFromSuperlayer];
    videoPreviewLayer=nil;
    if([[eventCamera sharedInstance] isRunning])
    {
        [[eventCamera sharedInstance] stopRunning];
        
    }
}

-(void)pauseCameraLayer
{
    if([[eventCamera sharedInstance] isRunning])
    {
        [[[[eventCamera sharedInstance] previewLayer] connection] setEnabled:NO];
        [self hideCameraButtons];
    }
}

-(void)resumeCameraLayer
{
    if(imagePreviewView!=nil)
    {
        NSLog(@"IN");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [imagePreviewView removeFromSuperview];
            imagePreviewView=nil;
        }];
    }
    if(![[eventCamera sharedInstance] isRunning])
    {
        [self addCameraView];
    }
    if([[eventCamera sharedInstance] isRunning])
    {
        [[[[eventCamera sharedInstance] previewLayer] connection] setEnabled:YES];
        [self hideGoodBadButtons];
        [self showCameraButtons];
    }
}

-(void)showGoodBadButtons
{
    [UIView animateWithDuration:.25 animations:^{
        for(UIButton *button in [self goodBadButtons])
        {
            [button setHidden:NO];
        }
    }];
}

-(void)hideGoodBadButtons
{
    [UIView animateWithDuration:.25 animations:^{
        for(UIButton *button in [self goodBadButtons])
        {
            [button setHidden:YES];
        }
    }];
}

-(void)hideCameraButtons
{
    CGFloat dimmedAlpha=.5;
    [_flashButton setHidden:YES];
    [_captureButton setUserInteractionEnabled:NO];
    [_captureButton setAlpha:dimmedAlpha];
    [_libraryBarImageView setUserInteractionEnabled:NO];
    [_libraryBarImageView setAlpha:dimmedAlpha];
    [_switchCameraButton setUserInteractionEnabled:NO];
    [_switchCameraButton setAlpha:dimmedAlpha];
}

-(void)showCameraButtons
{
    CGFloat dimmedAlpha=1;
    [UIView animateWithDuration:.25 animations:^{
        [_captureButton setAlpha:dimmedAlpha];
        [_libraryBarImageView setAlpha:dimmedAlpha];
        [_switchCameraButton setAlpha:dimmedAlpha];
        
    } completion:^(BOOL finished){
        [_libraryBarImageView setUserInteractionEnabled:YES];
        [_captureButton setUserInteractionEnabled:YES];
        [_switchCameraButton setUserInteractionEnabled:YES];
        [_flashButton setHidden:NO];
    }];
}

-(NSArray<UIButton*>*)goodBadButtons
{
    return @[_goodPictureButton, _badPictureButton];
}

-(NSArray<UIButton*>*)cameraButtons
{
    return @[_captureButton, _switchCameraButton, _flashButton];
}

//UIGestureRecognizerDelegate Methods
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    pinchStartScale=0;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)goodButtonPressed:(id)sender {
    [[event sharedInstance] setImage:[self captureImageView:imagePreviewView]];
    [self performSegueWithIdentifier:@"editPhoto" sender:nil];
}

-(UIImage*)captureImageView:(UIImageView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 5.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *im=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return im;
}

- (IBAction)badButtonPressed:(id)sender {
    NSLog(@"pressed");
    [self resumeCameraLayer];
    
}
- (IBAction)flashButtonPressed:(id)sender {
    if([eventCamera sharedInstance].captureFlashMode==AVCaptureFlashModeOff)
    {
        [eventCamera sharedInstance].captureFlashMode=AVCaptureFlashModeOn;
    }
    else
    {
        [eventCamera sharedInstance].captureFlashMode=AVCaptureFlashModeOff;
    }
    [self updateFlashButtonText];
}

//delegate methods to control UIImagepickerview to get photo from library
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image=nil;
    image=[info objectForKey:UIImagePickerControllerEditedImage];
    if(image==nil)
    {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(image==nil)
    {
        image=[info objectForKey:UIImagePickerControllerCropRect];
    }
    [self hideCameraButtons];
    imagePreviewView=[[UIImageView alloc] initWithImage:image];
    [imagePreviewView setAutoresizesSubviews:YES];
    [imagePreviewView setContentMode:UIViewContentModeScaleAspectFit];
    imagePreviewView.frame=_imageView.bounds;
    [self removeCameraView];
    [_imageView addSubview:imagePreviewView];
    [_imageView sendSubviewToBack:imagePreviewView];
    [self showGoodBadButtons];
    
}

//If editing photo is cancelled
-(void)prepareForUnwind:(UIStoryboardSegue*)segue
{
    if([[segue identifier] isEqualToString:@"cancelEditing"])
    {
        [self resumeCameraLayer];
    }
}

//Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
