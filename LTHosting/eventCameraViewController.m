//
//  ViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventCameraViewController.h"

@interface eventCameraViewController () {
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    
    CGFloat pinchStartScale;
    
    UIImageView *imagePreviewView;
    
    BOOL visible;
}
@end

@implementation eventCameraViewController

- (void)viewDidLoad {
    [self configureView];
    [super viewDidLoad];
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
    UITapGestureRecognizer *libraryTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(libraryBarTapped:)];
    [libraryTap setDelegate:self];
    [_libraryBar addGestureRecognizer:libraryTap];
    
    
    //Disable good and bad photo buttons until photo is taken
    [self hideGoodBadButtons];
    
    //Set most recent image in libary bar
    [self findMostRecentImage];
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
        [_libraryBarImageView setImage:retrieved];
        [_libraryBarImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_libraryBarImageView setBackgroundColor:[UIColor blackColor]];
    }];
}

-(IBAction)libraryBarTapped:(id)sender
{
    if(![_goodPictureButton isHidden])
    {
        return;
    }
    UIImagePickerController *pickerController=[[UIImagePickerController alloc] init];
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickerController setDelegate:self];
    [self presentViewController:pickerController animated:YES completion:^{
        NSLog(@"Completed");
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
    //[button.layer setDrawsAsynchronously:YES];
    //[button.layer setShouldRasterize:YES];
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

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchCameraView:(id)sender {
    //[captureInput setDevice:(id<MTLDevice>)[AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront]];
    [self removeCameraView];
    [[eventCamera sharedInstance] switchCamera];
    [self addCameraView];
}

- (IBAction)capturePhoto:(id)sender {
    
    [self hideCameraButtons];
    [[eventCamera sharedInstance] captureStillUIImage:^(UIImage *image, NSError *error){
        
        if(error)
        {
            NSLog(@"error capturing photo");
        }
        else
        {
            NSLog(@"%@",image.debugDescription);
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
        NSLog(@"1: %@",image.description);
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
        NSLog(@"it's on now");
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
        [_captureButton setHidden:NO];
        [_switchCameraButton setHidden:NO];
    }
}

-(void)showGoodBadButtons
{
    for(UIButton *button in [self goodBadButtons])
    {
        [button setHidden:NO];
    }
}

-(void)hideGoodBadButtons
{
    for(UIButton *button in [self goodBadButtons])
    {
        [button setHidden:YES];
    }
}

-(void)hideCameraButtons
{
    for(UIButton *button in [self cameraButtons])
    {
        [button setHidden:YES];
    }
    
}

-(void)showCameraButtons
{
    for(UIButton *button in [self cameraButtons])
    {
        [button setHidden:NO];
    }
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
    if(visible)
    {
        NSLog(@"ended");
    }
    pinchStartScale=0;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



- (IBAction)goodButtonPressed:(id)sender {
    [[event sharedInstance] setImage:imagePreviewView.image];
    [self performSegueWithIdentifier:@"editPhoto" sender:nil];
}

- (IBAction)badButtonPressed:(id)sender {
    NSLog(@"pressed");
    [self resumeCameraLayer];
    
}
- (IBAction)flashButtonPressed:(id)sender {
    if([eventCamera sharedInstance].captureFlashMode==AVCaptureFlashModeOff)
    {
        NSLog(@"turn on");
        [eventCamera sharedInstance].captureFlashMode=AVCaptureFlashModeOn;
    }
    else
    {
        NSLog(@"turn off");
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
    NSLog(@"called");
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
