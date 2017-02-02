//
//  smartBorderLayer.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartBorderLayer.h"
#import "commonUseFunctions.h"

@interface smartBorderLayer(){
    CGFloat currentCornerRadius;
    CALayer *mask;
    
    BOOL isMasking;
}
@end

@implementation smartBorderLayer

-(id)init
{
    self=[super init];
    _defaultInset=24;
    _defaultCornerRadius=0;
    _defaultBorderWidth=10;
    currentCornerRadius=_defaultCornerRadius;
    [self setShouldRasterize:YES];
    [self setRasterizationScale:10.0f];
    mask=[[CALayer alloc] init];
    self.mask=mask;
    isMasking=NO;
    return self;
}

+(smartBorderLayer*)newSmartBorderInParentRect:(CGRect)parentrect
{
    smartBorderLayer *new=[[smartBorderLayer alloc] init];
    new.currentInset=0;
    new.parentRect=parentrect;
    
    new.backgroundColor=nil;
    new.cornerRadius=new.defaultCornerRadius;
    [new setFrame:parentrect];
    [new setContentsGravity:kCAGravityResizeAspect];
    return new;
}

-(void)incrementInsetBy:(CGFloat)amount
{
    CGRect oldFrame=self.frame;
    [self setFrame:CGRectMake(oldFrame.origin.x+amount, oldFrame.origin.y+amount, oldFrame.size.width-(2*amount), oldFrame.size.height-(2*amount))];
    _currentInset+=amount;
}

-(void)incrementBorderWidthBy:(CGFloat)amount
{
    [self setBorderWidth:self.borderWidth+amount];
    [self incrementInsetBy:-amount/2.0f];
}

-(void)incrementCornerRadiusBy:(CGFloat)amount
{
    currentCornerRadius=amount+currentCornerRadius;
    [self setCornerRadius:currentCornerRadius];
}

/*-(void)setBorderWidth:(CGFloat)borderWidth
{
    [self incrementBorderWidthBy:borderWidth-_borderShapeLayer.borderWidth];
}*/

//popuptoolresponder methods
-(void)colorDidChangeTo:(CGColorRef)color
{
    [self setColor:color];
}

-(void)borderWidthDidChangeTo:(CGFloat)bwidth
{
    [self setBorderWidth:bwidth];
}

-(void)cornerRadiusDidChangeTo:(CGFloat)radius
{
    [self setCornerRadius:radius];
}

-(void)setBorderColor:(CGColorRef)borderColor
{
    [super setBorderColor:borderColor];
}

-(CGColorRef)color
{
    return self.backgroundColor;
}

-(void)setColor:(CGColorRef)color
{
    if(!isMasking)
    {
        isMasking=YES;
        [self setContents:nil];
    }
    [super setColor:color];
    self.backgroundColor=color;
    
}

-(void)setContents:(id)contents
{
    [super setContents:contents];
    if(!isMasking)
    {
        [mask setContents:contents];
    }
    else
    {
        isMasking=NO;
    }
    [self setBackgroundColor:[UIColor clearColor].CGColor];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [mask setFrame:self.bounds];
}

-(void)removeColor
{
    [self setContents:mask.contents];
    [self setBackgroundColor:[UIColor clearColor].CGColor];
}

@end
