//
//  editorView.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "editorView.h"

@interface editorView(){
    CALayer *backgroundLayer;
    CGSize imageSize;
    
    textEditingLayer *title;
    textEditingLayer *body;
    borderEditingLayer *border;
    CALayer *backgroundTintLayer;
    
    BOOL isEditing;
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
    backgroundTintLayer=[[tintEditinglayer alloc] init];
    backgroundTintLayer.backgroundColor=[UIColor blackColor].CGColor;
    backgroundTintLayer.opacity=0.0f;
    [backgroundLayer addSublayer:backgroundTintLayer];
    
    //Editing layers
    border=[[borderEditingLayer alloc] init];
    [backgroundLayer addSublayer:border];
    imageSize=CGSizeZero;
    
    [border setContentsGravity:kCAGravityResize];
    title=[[textEditingLayer alloc] init];
    title.flexibleHeight=YES;
    title.layoutManager=self;
    [self.layer addSublayer:title];
    body=[[textEditingLayer alloc] init];
    body.flexibleHeight=NO;
    body.layoutManager=self;
    [self.layer addSublayer:body];
    isEditing=YES;
    self.backgroundColor=[UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [tap addTarget:self action:@selector(touchUpInside:)];
    [self addGestureRecognizer:tap];
    
    _viewController=nil;
    return self;
}

-(IBAction)touchUpInside:(UITapGestureRecognizer*)tap
{
    [self beginEditingTextLayer:[self hitTest:[tap locationInView:self]]];
}

-(textEditingLayer*)hitTest:(CGPoint)point
{
    if(CGRectContainsPoint(body.frame, point))
    {
        return body;
    }
    if(CGRectContainsPoint(title.frame, point))
    {
        return title;
    }
    return nil;
}

-(void)reset
{
    instance=nil;
}


//Managing frame changes
-(void)setFrame:(CGRect)frame
{
    CGFloat propr=frame.size.height/self.frame.size.height;
    [super setFrame:frame];
    [self gravitateBackgroundLayer];
    [border setFrame:backgroundLayer.bounds];
    CGFloat proportion=MIN(backgroundLayer.frame.size.width,backgroundLayer.frame.size.height)/10.0f;
    CGFloat height=title.frame.size.height*propr;
    if(isnan(height))
    {
        height=0;
    }
    if(isnan(propr))
    {
        propr=0;
    }
    [title setFrame:CGRectMake(backgroundLayer.frame.origin.x+proportion, backgroundLayer.frame.origin.y+proportion, backgroundLayer.frame.size.width-proportion*2, height)];
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
    backgroundTintLayer.frame=backgroundLayer.bounds;
    if(cover!=nil)
    {
        [cover setFrame:backgroundLayer.frame];
    }
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

-(CALayer*)backgroundTintLayer
{
    return backgroundTintLayer;
}

-(void)updateImageContainerWithImage:(UIImage *)image
{
    backgroundLayer.affineTransform=CGAffineTransformIdentity;
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
    [border setAffineTransform:CGAffineTransformInvert(backgroundLayer.affineTransform)];
    [self setFrame:self.frame];
}

-(void)editingLayer:(editingLayer *)layer frameWillChangeTo:(CGRect)newFrame
{
    if(layer==title)
    {
        [body setFrame:[self bodyFrameForTitleFrame:newFrame]];
    }
}

-(CGRect)bodyFrameForTitleFrame:(CGRect)titleFrame
{
    CGFloat inset=titleFrame.origin.x-backgroundLayer.frame.origin.x;
    return CGRectMake(titleFrame.origin.x, titleFrame.origin.y+titleFrame.size.height, titleFrame.size.width, backgroundLayer.frame.size.height-titleFrame.size.height-inset*2);
}

-(void)setBodyText:(NSString *)bodya
{
    [body setText:bodya];
    [body setFont:[body.font fontWithSize:[body maxTextSize]]];
}

-(void)setTitleText:(NSString *)titlea
{
    [title setText:titlea];
}

UIImageView *cover=nil;

-(BOOL)isEditing
{
    return isEditing;
}

-(void)setIsEditing:(BOOL)isEditinga
{
    if(isEditinga!=isEditing)
    {
        if(!isEditinga)
        {
            cover=[[UIImageView alloc] initWithImage:[self currentImage]];
            cover.frame=self.bounds;
            cover.contentMode=UIViewContentModeScaleAspectFill;
            [self addSubview:cover];
            [self setLayersHidden:YES];
        }
        else
        {
            [UIView animateWithDuration:.05 animations:^{
                [self setLayersHidden:NO];
            } completion:^(BOOL finished){
                [UIView animateWithDuration:.05 animations:^{
                    cover.alpha=0;
                } completion:^(BOOL finished){
                    [cover removeFromSuperview];
                    cover=nil;
                }];
            }];
        }
        isEditing=isEditinga;
    }
}

-(void)setLayersHidden:(BOOL)hidden
{
    CGFloat target=0;
    if(!hidden)
    {
        target=1;
    }
    backgroundLayer.opacity=target;
    border.opacity=target;
    body.opacity=target;
    title.opacity=target;
}

-(UIImage*)currentImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 5.0f);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *im=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return im;
}

-(void)beginEditingTextLayer:(textEditingLayer*)textLayer
{
    if(self.viewController==nil||textLayer==nil)
    {
        return;
    }
    [self.viewController beginTextEditingWithLayer:textLayer];
}

@end
