//
//  LTImagePicker.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTImagePicker;

@protocol LTImagePickerDelegate <NSObject>

-(void)beginCameraModeWithImagePicker:(LTImagePicker*)picker;

-(void)endCameraModeWithImagePicker:(LTImagePicker*)picker completion:(void(^)())completionBlock;

-(void)imagePicker:(LTImagePicker*)picker didFinishChoosingWithImage:(UIImage*)image;

@end

@interface LTImagePicker : UIScrollView<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(void)reloadImagesWithCompletionBlock:(void(^)())completionBlock;

@property (nonatomic) NSInteger thumbnailsPerLine;

@property (weak, nonatomic) id<LTImagePickerDelegate> pickerDelegate;

@end
