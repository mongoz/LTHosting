//
//  LTImageManager.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface LTImageManager : NSObject

+(LTImageManager*)shared;

+(void)resetShared;

-(void)refreshPhotoAssets;

@property (readonly) NSArray<PHAsset*>* photoAssets;

-(void)requestImageForAsset:(PHAsset*)asset targetSize:(CGSize)size resultHandler:(void(^)(UIImage*))resultHandler;

-(void)requestImagesForAssets:(NSArray<PHAsset*>*)assets targetSize:(CGSize)size resultHandler:(void(^)(NSArray<UIImage*>*))resultHandler;

@end
