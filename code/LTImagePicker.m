//
//  LTImagePicker.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTImagePicker.h"
#import "LTImageManager.h"
#import "LTImagePickerThumbnail.h"

@interface LTImagePicker(){
    NSMutableArray<UIView*>* thumbnails;
    NSInteger currentNumberOfThumbnails;
    CGFloat margin;
    CGSize thumbnailSize;
}

@end

@implementation LTImagePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self=[super init];
    thumbnails=[[NSMutableArray alloc] init];
    thumbnailSize=CGSizeZero;
    currentNumberOfThumbnails=0;
    _thumbnailsPerLine=3;
    margin=4.0f;
    self.clipsToBounds=YES;
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self recalculateContentSize];
}

-(void)setFrame:(CGRect)frame
{
    CGFloat thumbnailHeight=(frame.size.width-margin*(_thumbnailsPerLine+1))/_thumbnailsPerLine;
    thumbnailSize=CGSizeMake(thumbnailHeight, thumbnailHeight);
    [super setFrame:frame];
}

-(void)reloadImagesWithCompletionBlock:(void (^)())completionBlock{
    [self reset];
    [[LTImageManager shared] refreshPhotoAssets];
    NSBlockOperation *mainblock=[NSBlockOperation blockOperationWithBlock:^{
        [self addCameraThumbnail];
        for(PHAsset *a in [LTImageManager shared].photoAssets){
            [self addThumbnailForAsset:a];
        }
        [self layoutIfNeeded];
        [self loadVisibleImages];
    }];
    [mainblock setCompletionBlock:completionBlock];
    [[NSOperationQueue mainQueue] addOperation:mainblock];
}

-(void)addThumbnailForAsset:(PHAsset*)asset{
    LTImagePickerThumbnail *nail=[self thumbnailForAsset:asset];
    nail.frame=[self nextThumbnailFrame];
    nail.index=currentNumberOfThumbnails;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailTapped:)];
    [nail addGestureRecognizer:tap];
    [self addSubview:nail];
    [thumbnails addObject:nail];
    currentNumberOfThumbnails++;
}

-(void)thumbnailTapped:(UITapGestureRecognizer*)tap{
    LTImagePickerThumbnail *nail=(LTImagePickerThumbnail*)tap.view;
    [self.pickerDelegate imagePicker:self didFinishChoosingWithImage:nail.image];
}

-(void)addThumbnailForImage:(UIImage*)image{
    UIImageView *nail=[self thumbnailForImage:image];
    nail.frame=[self nextThumbnailFrame];
    [self addSubview:nail];
    [thumbnails addObject:nail];
    currentNumberOfThumbnails++;
}

-(void)addCameraThumbnail{
    [self addThumbnailForImage:[UIImage imageNamed:@"camera event page.png"]];
    UIView *cameraNail=thumbnails.lastObject;
    cameraNail.contentMode=UIViewContentModeScaleAspectFit;
    cameraNail.backgroundColor=[UIColor whiteColor];
    cameraNail.layer.cornerRadius=4.0f;
    cameraNail.layer.borderWidth=2.0f;
    cameraNail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTapped:)];
    [cameraNail addGestureRecognizer:tap];
}

-(void)cameraTapped:(UITapGestureRecognizer*)tap{
    NSLog(@"camera button tapped");
    if(self.pickerDelegate!=nil){
        [self.pickerDelegate beginCameraModeWithImagePicker:self];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.pickerDelegate endCameraModeWithImagePicker:self completion:^{
    }];
    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    img = [UIImage imageWithCGImage:[img CGImage]];
    
    UIImageOrientation requiredOrientation = UIImageOrientationUp;
    switch ([[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue])
    {
        case 3:
            requiredOrientation = UIImageOrientationDown;
            break;
        case 6:
            requiredOrientation = UIImageOrientationRight;
            break;
        case 8:
            requiredOrientation = UIImageOrientationLeft;
            break;
        default:
            break;
    }
    
    UIImage *im = [[UIImage alloc] initWithCGImage:img.CGImage scale:img.scale orientation:requiredOrientation];
    [self.pickerDelegate imagePicker:self didFinishChoosingWithImage:im];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancelled");
    [self.pickerDelegate endCameraModeWithImagePicker:self completion:nil];
}

-(void)popThumbnail{
    [thumbnails.lastObject removeFromSuperview];
    [thumbnails removeObjectAtIndex:thumbnails.count-1];
    currentNumberOfThumbnails--;
}

-(LTImagePickerThumbnail*)thumbnailForAsset:(PHAsset*)asset{
    LTImagePickerThumbnail *nail=[[LTImagePickerThumbnail alloc] init];
    nail.asset=asset;
    return nail;
}

-(UIImageView*)thumbnailForImage:(UIImage*)image{
    UIImageView *nail=[[UIImageView alloc] initWithImage:image];
    nail.contentMode=UIViewContentModeScaleAspectFill;
    nail.image=image;
    nail.userInteractionEnabled=YES;
    nail.clipsToBounds=YES;
    return nail;
}

-(CGRect)nextThumbnailFrame{
    NSInteger onLine=currentNumberOfThumbnails%_thumbnailsPerLine;
    NSInteger fullLines=(currentNumberOfThumbnails-onLine)/_thumbnailsPerLine;
    return CGRectMake(margin+onLine*(margin+thumbnailSize.width), margin+fullLines*(margin+thumbnailSize.height), thumbnailSize.width, thumbnailSize.height);
}

-(void)recalculateContentSize{
    CGFloat height=margin+(thumbnailSize.height+margin)*[self currentNumberOfLinesUsed];
    self.contentSize=CGSizeMake(self.frame.size.width, height);
}

-(NSInteger)currentNumberOfLinesUsed
{
    return ceilf((float)currentNumberOfThumbnails/(float)_thumbnailsPerLine);
}

-(void)reset{
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    thumbnails=[[NSMutableArray alloc] init];
    currentNumberOfThumbnails=0;
}

-(void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    [self loadVisibleImages];
}

-(void)loadVisibleImages{
    CGRect visibilityFrame=CGRectMake(0, self.contentOffset.y-thumbnailSize.height, self.frame.size.width, self.frame.size.height+thumbnailSize.height*2);
    for(UIView *nail in thumbnails){
        if(nail.class==[LTImagePickerThumbnail class]){
            LTImagePickerThumbnail *ltnail=(LTImagePickerThumbnail*)nail;
            if(CGRectIntersectsRect(ltnail.frame, visibilityFrame)){
                ltnail.loadedImage=YES;
            }
            else{
                ltnail.loadedImage=NO;
            }
        }
    }
}

@end
