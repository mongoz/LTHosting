//
//  smartLayer.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartLayer.h"
#import "commonUseFunctions.h"

@protocol smartLayerDelegate <NSObject>



@end

@interface smartLayer(){
    float colorValue;
    
    NSInteger numberMovements;
    CGSize movementSum;
}

@end

@implementation smartLayer

-(id)init
{
    self=[super init];
    numberMovements=0;
    movementSum=CGSizeZero;
    return self;
}

-(void)moveToCenterPoint:(CGPoint)center
{
    CGPoint difference=CGPointMake(center.x-self.centerPoint.x, center.y-self.centerPoint.y);
    CGRect currentFrame=self.frame;
    [self setFrame:CGRectMake(currentFrame.origin.x+difference.x, currentFrame.origin.y+difference.y, currentFrame.size.width, currentFrame.size.height) animated:YES];
}

-(void)moveBy:(CGSize)distance
{
    [self moveBy:distance interval:.25];
}

-(void)moveBy:(CGSize)distance interval:(NSTimeInterval)interval
{
    numberMovements++;
    movementSum.width+=distance.width;
    movementSum.height+=distance.height;
    if(numberMovements>2)
    {
        [UIView animateWithDuration:interval animations:^{
            [self moveToCenterPoint:CGPointMake(_centerPoint.x+distance.width, _centerPoint.y+distance.height)];
        }];
    }
}

-(void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    if(!animated)
    {
        [self setFrame:frame];
    }
    else
    {
        [UIView animateWithDuration:.1 animations:^{
            [self setFrame:frame];
        }];
    }
}

-(void)setColor:(CGColorRef)color
{
    [_mirror layerDidChange:self];
}

-(void)setFrame:(CGRect)frame
{
    CGFloat scale=self.frame.size.width/frame.size.width;
    [super setFrame:frame];
    [self setCornerRadius:self.cornerRadius/scale];
    self.centerPoint=CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    [_mirror layerDidChange:self];
}

-(void)setMirror:(id<smartLayerMirror>)mirror
{
    _mirror=mirror;
    [_mirror layerWasCreated:self];
}

-(void)scaleBy:(CGFloat)scale
{
    CGSize newSize=CGSizeMake(self.frame.size.width*scale, self.frame.size.height*scale);
    [self setFrame:CGRectMake(_centerPoint.x-newSize.width/2, _centerPoint.y-newSize.height/2, newSize.width, newSize.height) animated:YES];
}

-(void)removeFromSuperlayer
{
    [super removeFromSuperlayer];
    [_mirror layerWasDeleted:self];
    _mirror=nil;
}

//popupToolResponder methods
-(void)colorDidChangeTo:(CGColorRef)color
{
    
}

-(float)colorValue
{
    return colorValue;
}

-(void)setColorValue:(float)val
{
    colorValue=val;
    [_mirror layerDidChange:self];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    [super setBorderWidth:borderWidth];
    [_mirror layerDidChange:self];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    [super setCornerRadius:cornerRadius];
    [_mirror layerDidChange:self];
}

@end
