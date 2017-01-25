//
//  smartLayerThumbnail.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartLayerThumbnail.h"
#import "imageEditorView.h"
#import "commonUseFunctions.h"

@interface smartLayerThumbnail(){
    CALayer *previewLayer;
    
    BOOL isPortrait;
    BOOL isSelected;
    
    smartLayer *sourceLayer;
    
    CGColorRef normalColor;
    CGColorRef selectedColor;
    
    BOOL isMovingFreely;
    
    CGPoint longPLoc;
    
    CGRect originalFrame;
    
    CGFloat movingScale;
}
@end

@implementation smartLayerThumbnail

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    normalColor=[UIColor lightGrayColor].CGColor;
    selectedColor=[UIColor grayColor].CGColor;
    self=[super initWithFrame:frame];
    [self setBackgroundColor:[UIColor blackColor]];
    [self.layer setBackgroundColor:normalColor];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:1];
    previewLayer=nil;
    sourceLayer=nil;
    isPortrait=NO;
    isSelected=NO;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [tap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPressed:)];
    [longPress setMinimumPressDuration:1];
    [self addGestureRecognizer:longPress];
    
    [self.layer setMasksToBounds:YES];
    
    isMovingFreely=NO;
    longPLoc=CGPointZero;
    movingScale=1.1;
    
    //[self.layer setContentsGravity:kCAGravityResizeAspect];
    
    return self;
}

-(IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    if(!isSelected){
        [[imageEditorView sharedInstance] setSelectedLayer:sourceLayer];
        originalFrame=self.frame;
    }
}

-(IBAction)viewLongPressed:(UILongPressGestureRecognizer*)press
{
    [self viewTapped:nil];
    if([press state]==UIGestureRecognizerStateEnded)
    {
        longPLoc=CGPointZero;
        isMovingFreely=NO;
        if([self point:self.center isWithinRect:_trashFrame])
        {
            [_manager thumbnailCenterDidEnterTrashFrame:self];
        }
        else{
            [self bounceBackToOriginalFrame];
        }
    }
    else
    {
        CGPoint loc=[press locationInView:self];
        if(longPLoc.x==CGPointZero.x&&longPLoc.y==CGPointZero.y)
        {
            longPLoc=loc;
        }
        else
        {
            if(!isMovingFreely)
            {
                [UIView animateWithDuration:.2 animations:^{
                    [self scaleBy:movingScale];
                }];
                isMovingFreely=YES;
            }
            CGSize diff=CGSizeMake(loc.x-longPLoc.x, loc.y-longPLoc.y);
            [self moveBy:diff];
        }
    }
}

-(void)moveBy:(CGSize)distance
{
    [self setFrame:CGRectMake(self.frame.origin.x+distance.width, self.frame.origin.y+distance.height, self.frame.size.width, self.frame.size.height)];
}

-(void)scaleBy:(CGFloat)scale
{
    [self setFrame:CGRectMake(self.frame.origin.x+self.frame.size.width/2-(self.frame.size.width*scale)/2, self.frame.origin.y+self.frame.size.height/2-(self.frame.size.height*scale)/2, self.frame.size.width*scale, self.frame.size.height*scale)];
}

-(void)layerDidChange:(smartLayer *)layer
{
    [previewLayer removeFromSuperlayer];
    [self layerWasCreated:layer];
}

-(void)layerWasCreated:(smartLayer *)layer
{
    sourceLayer=layer;
    CGRect parentFrame=layer.parentRect;
    if(parentFrame.size.height>=parentFrame.size.width)
    {
        isPortrait=YES;
    }
    else
    {
        isPortrait=NO;
    }
    CGFloat scale=1;
    CGFloat xBuffer=0;
    CGFloat yBuffer=0;
    if(isPortrait)
    {
        scale=self.frame.size.height/parentFrame.size.height;
        xBuffer=(self.frame.size.width-(parentFrame.size.width*scale))/2;
    }
    else
    {
        scale=self.frame.size.width/parentFrame.size.width;
        yBuffer=(self.frame.size.height-(parentFrame.size.height*scale))/2;
    }
    CGRect myNewRect=CGRectMake(layer.frame.origin.x*scale+xBuffer, layer.frame.origin.y*scale+yBuffer, layer.frame.size.width*scale, layer.frame.size.height*scale);
    previewLayer=[[CALayer alloc] initWithLayer:layer.presentationLayer];
    [previewLayer setFrame:myNewRect];
    if(!previewLayer)
    {
        NSLog(@"nope");
    }
    [previewLayer setBorderColor:layer.borderColor];
    [previewLayer setBorderWidth:layer.borderWidth*scale];
    [previewLayer setCornerRadius:layer.cornerRadius*scale];
    [previewLayer setBorderColor:layer.borderColor];
    
    if([layer class]==[smartTextLayer class])
    {
        smartTextLayer *thisLayer=(smartTextLayer*)layer;
        CALayer *temp=[CALayer layer];
        [temp setFrame:previewLayer.bounds];
        [temp setBackgroundColor:thisLayer.textLayer.textColor.CGColor];
        [previewLayer addSublayer:temp];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.layer addSublayer:previewLayer];
    }];
    [self viewTapped:nil];
}

-(void)layerWasDeleted:(smartLayer *)layer
{
    [self layerWasDeselected];
    [_manager layerWasPoppedForThumbnail:self];
}

-(void)layerWasSelected
{
    if(sourceLayer==nil)
    {
        return;
    }
    if([sourceLayer class]==[smartTextLayer class])
    {
        smartTextLayer *temp=(smartTextLayer*)sourceLayer;
        if([temp.textLayer.text isEqualToString:@""])
        {
            [_manager thumbnailCenterDidEnterTrashFrame:self];
            return;
        }
    }
    isSelected=YES;
    [self.layer setBackgroundColor:selectedColor];
    if([self.manager respondsToSelector:@selector(layerWasSelected:)])
    {
        [self.manager layerWasSelected:self];
    }
}

-(void)layerWasDeselected
{
    if(sourceLayer==nil)
    {
        return;
    }
    isSelected=NO;
    [self.layer setBackgroundColor:normalColor];
    if([self.manager respondsToSelector:@selector(layerWasDeselected:)])
    {
        [self.manager layerWasDeselected:self];
    }
}

-(void)bounceBackToOriginalFrame
{
    CGSize diff=CGSizeMake(CGRectGetMidX(originalFrame)-CGRectGetMidX(self.frame), CGRectGetMidY(originalFrame)-CGRectGetMidY(self.frame));
    [UIView animateWithDuration:.2 animations:^{
        [self moveBy:diff];
        [self scaleBy:1/movingScale];
    } completion:^(BOOL finished){
    }];
}

-(void)printRect:(CGRect)rect
{
    NSLog(@"x: %f, y: %f, w: %f, h: %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

-(BOOL)point:(CGPoint)pt isWithinRect:(CGRect)rect
{
    if(rect.origin.x<pt.x&&pt.x<rect.origin.x+rect.size.width&&rect.origin.y<pt.y&&pt.y<rect.origin.y+rect.size.height)
    {
        return YES;
    }
    return NO;
}

-(BOOL)isSelected
{
    return isSelected;
}

-(void)setFrame:(CGRect)frame
{
    CGSize scale=CGSizeMake(frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
    [super setFrame:frame];
    [previewLayer setFrame:CGRectMake(previewLayer.frame.origin.x*scale.width, previewLayer.frame.origin.y*scale.height, previewLayer.frame.size.width*scale.width, previewLayer.frame.size.height*scale.height)];
}

-(smartLayer*)sourceLayer
{
    return sourceLayer;
}

@end
