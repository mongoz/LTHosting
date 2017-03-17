//
//  LTImagePickerViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTImagePicker.h"

@class LTImagePickerController;

@protocol LTImagePickerControllerDelegate <NSObject>

-(void)controller:(LTImagePickerController*)controller didFinishPickingImage:(UIImage*)image;

-(void)controllerDidCancelPicking:(LTImagePickerController*)controller;

@end

@interface LTImagePickerController : UIViewController<LTImagePickerDelegate>

@property (strong, nonatomic) LTImagePicker *pickerView;

@property (weak, nonatomic) id<LTImagePickerControllerDelegate> delegate;

@end
