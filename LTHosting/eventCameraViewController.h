//
//  ViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "eventCamera.h"
#import <Photos/Photos.h>
#import "event.h"

@interface eventCameraViewController : UIViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *imageView;

- (IBAction)backPressed:(id)sender;

- (IBAction)switchCameraView:(id)sender;

- (IBAction)capturePhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *switchCameraButton;

@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIButton *goodPictureButton;

@property (strong, nonatomic) IBOutlet UIButton *badPictureButton;

- (IBAction)goodButtonPressed:(id)sender;

- (IBAction)badButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *flashButton;

- (IBAction)flashButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *libraryBar;

@property (strong, nonatomic) IBOutlet UIImageView *libraryBarImageView;

-(void)prepareForUnwind:(UIStoryboardSegue*)seg;

@end

