//
//  LTImagePickerThumbnail.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface LTImagePickerThumbnail : UIImageView

@property (nonatomic) BOOL loadedImage;

@property (strong, nonatomic) PHAsset *asset;

@property (nonatomic) NSInteger index;

@end
