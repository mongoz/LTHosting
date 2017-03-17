//
//  LTImagePickerThumbnail.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTImagePickerThumbnail.h"

@interface LTImagePickerThumbnail(){
    BOOL imageLoaded;
    PHAsset *myAsset;
}

@end

@implementation LTImagePickerThumbnail

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self=[super init];
    imageLoaded=NO;
    self.asset=nil;
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.contentMode=UIViewContentModeScaleAspectFill;
    self.clipsToBounds=YES;
    self.userInteractionEnabled=YES;
    return self;
}

-(BOOL)loadedImage{
    return imageLoaded;
}

-(void)setLoadedImage:(BOOL)loadedImage{
    if(self.loadedImage!=loadedImage){
        if(loadedImage){
            [self loadImage];
        }
        else{
            self.image=nil;
        }
        imageLoaded=loadedImage;
    }
}

-(PHAsset*)asset{
    return myAsset;
}

-(void)setAsset:(PHAsset *)asset{
    myAsset=asset;
    self.image=nil;
    self.loadedImage=NO;
}

-(void)loadImage{
    if(self.asset==nil){
        return;
    }
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:self.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *im, NSDictionary *info){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.image=im;
        }];
    }];
}

@end
