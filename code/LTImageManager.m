//
//  LTImageManager.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTImageManager.h"

@interface LTImageManager(){
    NSArray<PHAsset*>* photoAssets;
    NSInteger currentRequestID;
}

@end

@implementation LTImageManager

static LTImageManager *sharedImageManager=nil;
+(LTImageManager*)shared{
    if(sharedImageManager==nil){
        sharedImageManager=[[LTImageManager alloc] init];
    }
    return sharedImageManager;
}

+(void)resetShared{
    sharedImageManager=nil;
}

-(id)init{
    self=[super init];
    [self refreshPhotoAssets];
    currentRequestID=-1;
    return self;
}

-(void)refreshPhotoAssets{
    photoAssets=[self fetchPhotoAssets];
    photoAssets=[photoAssets sortedArrayUsingComparator:^NSComparisonResult(PHAsset *one, PHAsset *two){
        return [two.creationDate compare:one.creationDate];
    }];
}

-(NSArray<PHAsset*>*)photoAssets{
    return photoAssets;
}

-(NSArray<PHAsset*>*)fetchPhotoAssets{
    PHFetchResult *result=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSMutableArray<PHAsset*>* ims=[[NSMutableArray alloc] init];
    for(PHAsset *asset in result){
        [ims addObject:asset];
    }
    return ims;
}

-(void)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)size resultHandler:(void (^)(UIImage *))resultHandler{
    currentRequestID=[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info){
        if(resultHandler!=nil){
            resultHandler(result);
        }
    }];
}

-(void)requestImagesForAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)size resultHandler:(void (^)(NSArray<UIImage *> *))resultHandler
{
    NSMutableArray *ims=[[NSMutableArray alloc] init];
    PHImageRequestOptions *ops=[[PHImageRequestOptions alloc] init];
    ops.synchronous=YES;
    NSBlockOperation *blockop=[NSBlockOperation blockOperationWithBlock:^{
        for(PHAsset *ass in assets){
            [[PHImageManager defaultManager] requestImageForAsset:ass targetSize:size contentMode:PHImageContentModeAspectFill options:ops resultHandler:^(UIImage *im, NSDictionary *info){
                [ims addObject:im];
            }];
        }
    }];
    [blockop setCompletionBlock:^{
        if(resultHandler!=nil){
            resultHandler(ims);
        }
    }];
    [[NSOperationQueue new] addOperation:blockop];
}

@end
