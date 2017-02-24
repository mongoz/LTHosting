//
//  borderPicker.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "borderPicker.h"
#import "usefulArray.h"
#import "editorView.h"
#import "borderEditingLayer.h"
#import "textEditingLayer.h"

@interface borderPicker(){
    horizontalViewPicker *scroller;
}

@end

@implementation borderPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

CGFloat margin=12;

static NSInteger selectedIndex=0;

+(NSInteger)selectedIndex
{
    return selectedIndex;
}

-(id)init
{
    self=[super init];
    scroller=nil;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(scroller==nil&frame.size.height>0)
    {
        scroller=[[horizontalViewPicker alloc] initWithFrame:self.bounds];
        [scroller setHeightWidthRatio:640.0f/480.0f];
        [scroller setLabelTextColor:[UIColor blackColor]];
        scroller.hDelegate=self;
        scroller.dataSource=self;
        [self addSubview:scroller];
        [scroller selectRowAtIndex:selectedIndex];
    }
    if(scroller!=nil)
    {
        [scroller setFrame:[self visibleFrame]];
    }
}

-(CGRect)frameForIndex:(NSInteger)index
{
    CGFloat height=self.frame.size.height-margin*2;
    CGSize size=CGSizeMake(height/scroller.heightWidthRatio, height);
    return CGRectMake(margin*(index+1)+size.width*index, margin, size.width, size.height);
}


-(CGRect)visibleFrame
{
    return CGRectMake(scroller.contentOffset.x, scroller.contentOffset.y, scroller.frame.size.width, scroller.frame.size.height);
}

//Horizontal picker view
-(UIView*)viewForIndex:(NSInteger)index
{
    UIImageView *base=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.png"]];
    [base setBackgroundColor:[UIColor blackColor]];
    [base.layer setContentsGravity:kCAGravityResizeAspectFill];
    [base setAutoresizesSubviews:YES];
    [base setTranslatesAutoresizingMaskIntoConstraints:YES];
    [base.layer setMasksToBounds:YES];
    [base setFrame:CGRectMake(0, 0, 100, 100)];
    if(index==0)
    {
        return base;
    }
    UIImage *im=[usefulArray borderImages][index-1];
    CGSize newSize=[self frameForIndex:index].size;
    UIImageView *new=[[UIImageView alloc] initWithImage:[self resizeImage:im newSize:newSize]];
    [new setContentMode:UIViewContentModeScaleToFill];
    [new setFrame:base.frame];
    new.layer.masksToBounds=YES;
    [base addSubview:new];
    return base;
    
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSInteger)numberOfViews
{
    return [usefulArray borderNames].count+1;
}

-(BOOL)shouldUseLabels
{
    return YES;
}

-(BOOL)shouldHandleViewResizing
{
    return YES;
}

-(UIView*)view:(UIView *)view inFrame:(CGRect)frame
{
    [view setFrame:frame];
    for(UIView *vi in view.subviews)
    {
        [vi setFrame:view.bounds];
    }
    return view;
}

-(NSString*)labelForIndex:(NSInteger)index
{
    if(index==0)
    {
        return @"";
    }
    return [usefulArray borderNames][index-1];
}

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index
{
    selectedIndex=index;
    if(index==0)
    {
        [[editorView shared] setBorder:nil];
        return;
    }
    [[editorView shared] setBorder:[usefulArray borderImages][index-1]];
    if(self.toolDelegate!=nil&&[self.toolDelegate respondsToSelector:@selector(toolValueChanged:)])
    {
        [self.toolDelegate toolValueChanged:self];
    }
}



@end
