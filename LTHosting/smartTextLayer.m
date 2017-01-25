//
//  smartTextLayer.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartTextLayer.h"
#import "commonUseFunctions.h"
#import "collapsingFrameQueue.h"
@interface smartTextLayer(){
    CGFloat currentScale;
    
    collapsingFrameQueue *frameChangeManager;
    
    BOOL hasTightened;
    
    NSInteger numScalers;
    CGFloat scalerProduct;
    CGFloat cumScale;
    
    NSInteger numMovers;
    CGSize movementSum;
}
@end

@implementation smartTextLayer

-(id)init
{
    self=[super init];
    _textLayer=nil;
    _sourceTextView=nil;
    currentScale=1.0f;
    frameChangeManager=nil;
    hasTightened=NO;
    numScalers=0;
    scalerProduct=1.0f;
    cumScale=1.0f;
    numMovers=0;
    movementSum=CGSizeZero;
    return self;
}

+(smartTextLayer*)newSmartTextLayerInParentRect:(CGRect)parentRect withTextView:(UITextView *)textView
{
    
    smartTextLayer *new=[[smartTextLayer alloc] init];
    new.parentRect=parentRect;
    
    new.textLayer=[[UILabel alloc] initWithFrame:textView.frame];
    [new.textLayer setAttributedText:textView.attributedText];
    [new.textLayer setTextColor:textView.textColor];
    [new.textLayer setLineBreakMode:NSLineBreakByWordWrapping];
    [new.textLayer setNumberOfLines:[textView numberOfLines]];
    [new.textLayer setLineBreakMode:NSLineBreakByClipping];
    [new.textLayer setTextAlignment:NSTextAlignmentLeft];
    [new addSublayer:new.textLayer.layer];
    //[new addSublayer:new.textLayer];
    //[new setSourceTextView:[textView copy]];
    //[new addSublayer:new.sourceTextView.layer];
    [new setContents:[UIImage imageForLayer:textView.layer]];
    [new setFrame:CGRectZero];
    [new tightenBoundingRect];
    [new display];
    [new setMasksToBounds:NO];
    return new;
}

-(void)setSourceTextView:(UITextView*)stView
{
    _sourceTextView=stView;
}

-(void)tightenBoundingRect
{
    CGRect startRect=self.frame;
    if(cumScale==1)
    {
        startRect=self.parentRect;
    }
    CGRect adjustedRect=CGRectMake(startRect.origin.x, startRect.origin.y, self.parentRect.size.width*cumScale, self.parentRect.size.height*cumScale);
    [self setFrame:adjustedRect];
    CGRect newRect=[_textLayer textRectForBounds:self.bounds limitedToNumberOfLines:0];
    
    [self setFrame:CGRectMake(startRect.origin.x, startRect.origin.y, newRect.size.width, newRect.size.height)];
    hasTightened=YES;
    //[_textLayer setAdjustsFontSizeToFitWidth:YES];
    [_textLayer setMinimumScaleFactor:1/10];
    [_textLayer setNumberOfLines:[_textLayer currentNumberOfLines]];
    [_textLayer setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_textLayer setFrame:self.bounds];
    
}

-(void)scaleBy:(CGFloat)scale
{
    scalerProduct*=scale;
    cumScale*=scale;
    numScalers++;
    if(numScalers>1)
    {
        [UIView animateWithDuration:.3 animations:^{
            [super scaleBy:scalerProduct];
            [_textLayer setFont:[_textLayer.font fontWithSize:_textLayer.font.pointSize*scalerProduct]];
        }];
        scalerProduct=1.0f;
        numScalers=0;
    }
}

-(CGColorRef)color
{
    return [_textLayer textColor].CGColor;
}

-(void)setColor:(CGColorRef)color
{
    [super setColor:color];
    [_textLayer setTextColor:[UIColor colorWithCGColor:color]];
}

//popuptoolresponder methods
-(void)colorDidChangeTo:(CGColorRef)color
{
    [self setColor:color];
}

-(void)moveBy:(CGSize)distance
{
    numMovers++;
    movementSum.width+=distance.width;
    movementSum.height+=distance.height;
    if(numMovers>2)
    {
        [super moveBy:movementSum interval:.5];
        numMovers=0;
        movementSum=CGSizeZero;
    }
}

-(void)fontDidChangeTo:(UIFont *)font
{
    NSLog(@"called");
    [_textLayer setFont:[font fontWithSize:_textLayer.font.pointSize]];
    [self tightenBoundingRect];
}

-(void)textAlignmentDidChangeTo:(NSTextAlignment)alignment
{
    [_textLayer setTextAlignment:alignment];
}

-(void)centerView
{
    CGPoint center=CGPointMake(CGRectGetMidX(self.parentRect), CGRectGetMidY(self.parentRect));
    CGSize diff=CGSizeMake(center.x-self.centerPoint.x, center.y-self.centerPoint.y);
    [UIView animateWithDuration:.3 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x+diff.width, self.frame.origin.y+diff.height, self.frame.size.width, self.frame.size.height)];
    }];
}

-(NSTextAlignment)textAlignment
{
    return _textLayer.textAlignment;
}

@end
