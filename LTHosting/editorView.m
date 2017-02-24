//
//  editorView.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "editorView.h"
#import "textEditingLayer.h"
#import "borderEditingLayer.h"

@interface editorView(){
    CALayer *backgroundLayer;
    CGSize imageSize;
    
    textEditingLayer *title;
    textEditingLayer *body;
    borderEditingLayer *border;
}

@end

@implementation editorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



static editorView *instance=nil;
//Initialization and managing instance
+(id)shared
{
    if(instance==nil)
    {
        instance=[[self alloc] init];
    }
    return instance;
}

-(id)init
{
    self=[super init];
    //Background layer
    backgroundLayer=[CALayer layer];
    [self.layer addSublayer:backgroundLayer];
    [backgroundLayer setContentsGravity:kCAGravityResizeAspect];
    
    //Editing layers
    border=[[borderEditingLayer alloc] init];
    [backgroundLayer addSublayer:border];
    imageSize=CGSizeZero;
    
    [border setContentsGravity:kCAGravityResize];
    title=[[textEditingLayer alloc] init];
    [self.layer addSublayer:title];
    body=[[textEditingLayer alloc] init];
    [self.layer addSublayer:body];
    
    return self;
}

-(void)reset
{
    instance=nil;
}


//Managing frame changes
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self gravitateBackgroundLayer];
    [border setFrame:backgroundLayer.bounds];
}

-(void)gravitateBackgroundLayer
{
    if(imageSize.width<=0||imageSize.height<=0)
    {
        return;
    }
    CGSize newSize=self.bounds.size;
    if(imageSize.height/imageSize.width>newSize.height/newSize.width)
    {
        newSize=CGSizeMake(newSize.height*imageSize.width/imageSize.height, newSize.height);
    }
    else
    {
        newSize=CGSizeMake(newSize.width, newSize.width*imageSize.height/imageSize.width);
    }
    [backgroundLayer setFrame:CGRectMake(self.bounds.size.width/2-newSize.width/2, self.bounds.size.height/2-newSize.height/2, newSize.width, newSize.height)];
}

//Managing contents of background & border layers
-(void)setImage:(UIImage *)image
{
    imageSize=image.size;
    [self updateImageContainerWithImage:image];
}

-(void)setBorder:(UIImage *)bimage
{
    border.backgroundColor=[UIColor clearColor].CGColor;
    [border setContents:(id)bimage.CGImage];
    border.mask=nil;
}

//Getter functions for editing layers

-(textEditingLayer*)titleLayer
{
    return title;
}

-(textEditingLayer*)bodyLayer
{
    return body;
}

-(borderEditingLayer*)borderLayer
{
    return border;
}

-(void)updateImageContainerWithImage:(UIImage *)image
{
    if(image.imageOrientation!=UIImageOrientationUp)
    {
        if(image.imageOrientation==UIImageOrientationLeftMirrored)
        {
            backgroundLayer.affineTransform=CGAffineTransformScale(backgroundLayer.affineTransform, -1, 1);
        }
        [backgroundLayer setAffineTransform:CGAffineTransformRotate(backgroundLayer.affineTransform,M_PI_2)];
    }
    [backgroundLayer setContentsGravity:kCAGravityResizeAspect];
    [backgroundLayer setContents:(id)image.CGImage];
    imageSize=image.size;
    [border setContents:nil];
    [self setFrame:self.frame];
}

@end
