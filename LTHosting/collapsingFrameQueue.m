//
//  collapsingFrameQueue.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "collapsingFrameQueue.h"

@interface collapsingFrameQueue(){
    CGSize originChange;
    CGFloat scaleChange;
    
    CGRect originalFrame;
    
    CGRect destinationFrame;
    
    BOOL isRunning;
}
@end

@implementation collapsingFrameQueue

-(id)initWithDestinationLayer:(CALayer *)destLayer
{
    self=[super init];
    _destinationLayer=destLayer;
    originalFrame=_destinationLayer.frame;
    scaleChange=1.0f;
    originChange=CGSizeZero;
    isRunning=NO;
    destinationFrame=originalFrame;
    return self;
}

-(void)updateDestinationFrame
{
    destinationFrame=CGRectMake(originalFrame.origin.x+originChange.width, originalFrame.origin.y+originChange.height, originalFrame.size.width*scaleChange, originalFrame.size.height*scaleChange);
    [self destinationFrameChanged];
}

-(void)addScaleBy:(CGFloat)scale
{
    if(scale==1.0f)
    {
        return;
    }
    scaleChange*=scale;
    [self updateDestinationFrame];
}

-(void)addOriginChange:(CGSize)change
{
    if(change.width==CGSizeZero.width&&change.height==CGSizeZero.height)
    {
        return;
    }
    originChange=CGSizeMake(originChange.width+change.width, originChange.height+change.height);
    [self updateDestinationFrame];
}

-(void)destinationFrameChanged
{
    if(!isRunning)
    {
        [self run];
    }
}

-(void)incrementFrameAtKeyPath:(NSString*)keyPath by:(CGFloat)amount
{
    CGFloat fromValue=[[_destinationLayer valueForKeyPath:keyPath] floatValue];
    CGFloat toValue=fromValue+amount;
    if([keyPath isEqualToString:@"origin.x"])
    {
        [_destinationLayer setFrame:CGRectMake(toValue, _destinationLayer.frame.origin.y, _destinationLayer.frame.size.width, _destinationLayer.frame.size.height)];
    }
    else if([keyPath isEqualToString:@"origin.y"])
    {
        [_destinationLayer setFrame:CGRectMake(_destinationLayer.frame.origin.x, toValue, _destinationLayer.frame.size.width, _destinationLayer.frame.size.height)];
    }
    else if([keyPath isEqualToString:@"size.width"])
    {
        [_destinationLayer setFrame:CGRectMake(_destinationLayer.frame.origin.x, _destinationLayer.frame.origin.y, toValue, _destinationLayer.frame.size.height)];
        
    }
    else if([keyPath isEqualToString:@"size.height"])
    {
        [_destinationLayer setFrame:CGRectMake(_destinationLayer.frame.origin.x, _destinationLayer.frame.origin.y, _destinationLayer.frame.size.width, toValue)];
    }
}

-(void)run
{
    isRunning=YES;
    CGFloat margin=5;
    CGRect currentFrame=_destinationLayer.frame;
    void (^incrementIfNeeded)(CGFloat,NSString*)=^(CGFloat currentD, NSString *keyPath)
    {
        if(currentD>margin)
        {
            [self incrementFrameAtKeyPath:keyPath by:-margin];
        }
        else if(currentD<-margin)
        {
            [self incrementFrameAtKeyPath:keyPath by:margin];
        }
    };
    while(fabs(currentFrame.origin.x-destinationFrame.origin.x)>margin||fabs(currentFrame.origin.y-destinationFrame.origin.y)>margin||fabs(currentFrame.size.width-destinationFrame.size.width)>margin||fabs(currentFrame.size.height-destinationFrame.size.height)>margin)
    {
        CGFloat currentDiff=currentFrame.origin.x-destinationFrame.origin.x;
        incrementIfNeeded(currentDiff, @"origin.x");
        currentDiff=currentFrame.origin.y-destinationFrame.origin.y;
        incrementIfNeeded(currentDiff, @"origin.y");
        currentDiff=currentFrame.size.width-destinationFrame.size.width;
        incrementIfNeeded(currentDiff, @"size.width");
        currentDiff=currentFrame.size.height-destinationFrame.size.height;
        incrementIfNeeded(currentDiff, @"size.height");
    }
    NSLog(@"frame changes ended");
    isRunning=NO;
}



@end
