//
//  smartTextLayer.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartTextLayer.h"
#import "commonUseFunctions.h"
@interface smartTextLayer(){
    CGFloat currentScale;
    
    BOOL hasTightened;
    
    NSInteger numScalers;
    CGFloat scalerProduct;
    CGFloat cumScale;
    
    NSInteger numMovers;
    CGSize movementSum;
    BOOL flexHeight;
}
@end

@implementation smartTextLayer

-(id)init
{
    self=[super init];
    _textLayer=nil;
    _sourceTextView=nil;
    currentScale=1.0f;
    hasTightened=NO;
    numScalers=0;
    scalerProduct=1.0f;
    cumScale=1.0f;
    numMovers=0;
    movementSum=CGSizeZero;
    flexHeight=NO;
    return self;
}

-(id)initWithParentRect:(CGRect)parentRect attributedString:(NSAttributedString *)string
{
    self=[self initWithParentRect:parentRect attributedString:string font:nil];
    return self;
}

-(id)initWithParentRect:(CGRect)parentRect attributedString:(NSAttributedString *)string font:(UIFont *)font
{
    self=[self init];
    self.parentRect=parentRect;
    [self setFrame:parentRect];
    
    self.textLayer=[[UILabel alloc] initWithFrame:self.bounds];
    [self.textLayer setNumberOfLines:0];
    //[self.textLayer setLineBreakMode:NSLineBreakByClipping];
    [self.textLayer setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLayer setTextAlignment:NSTextAlignmentLeft];
    [self.textLayer setAttributedText:string];
    if(font!=nil)
    {
        [self.textLayer setFont:font];
    }
    [self addSublayer:self.textLayer.layer];
    //[self setFrame:CGRectZero];
    //[self tightenBoundingRect];
    [self setMasksToBounds:NO];
    return self;
}

-(void)setFlexibleHeight:(BOOL)flexibleHeight
{
    flexHeight=flexibleHeight;
    if(flexHeight)
    {
        [self tightenBoundingRect];
    }
}

-(BOOL)flexibleHeight
{
    return flexHeight;
}

+(smartTextLayer*)newSmartTextLayerInParentRect:(CGRect)parentRect withTextView:(UITextView *)textView
{
    
    smartTextLayer *new=[[smartTextLayer alloc] init];
    new.parentRect=parentRect;
    
    new.textLayer=[[UILabel alloc] initWithFrame:textView.frame];
    [new.textLayer setAttributedText:textView.attributedText];
    [new.textLayer setTextColor:textView.textColor];
    [new.textLayer setLineBreakMode:NSLineBreakByWordWrapping];
    [new.textLayer setNumberOfLines:0];
    [new.textLayer setLineBreakMode:NSLineBreakByClipping];
    [new.textLayer setTextAlignment:NSTextAlignmentLeft];
    [new addSublayer:new.textLayer.layer];
    //[new addSublayer:new.textLayer];
    //[new setSourceTextView:[textView copy]];
    //[new addSublayer:new.sourceTextView.layer];
    [new setFrame:CGRectZero];
    [new tightenBoundingRect];
    [new displayIfNeeded];
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
    CGRect newRect=[_textLayer textRectForBounds:adjustedRect limitedToNumberOfLines:0];
    
    [self setFrame:CGRectMake(startRect.origin.x, startRect.origin.y, startRect.size.width, newRect.size.height)];
    hasTightened=YES;
    //[_textLayer setAdjustsFontSizeToFitWidth:YES];
    [_textLayer setMinimumScaleFactor:1/10];
    [_textLayer setNumberOfLines:0];
    [_textLayer setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect textRect=[_textLayer textRectForBounds:self.bounds limitedToNumberOfLines:NSIntegerMax];
    [_textLayer setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, textRect.size.height)];
    
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
    [_textLayer setFont:[font fontWithSize:_textLayer.font.pointSize]];
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

-(void)setText:(NSString *)text
{
    [_textLayer setText:text];
    while([_textLayer attributedText].size.width*_textLayer.attributedText.size.height>self.frame.size.width*self.frame.size.height)
    {
        [_textLayer setFont:[_textLayer.font fontWithSize:_textLayer.font.pointSize-1.0f]];
    }
    [self fontSizeDidChangeTo:self.textLayer.font.pointSize];
}

-(void)removeColor
{
    [self setColor:[UIColor whiteColor].CGColor];
}

-(CGFloat)maxTextSize
{
    if(!self.flexibleHeight)
    {
        CGFloat currentSize=1.0f;
        BOOL isTooBig=NO;
        while(!isTooBig)
        {
            currentSize+=1.0f;
            UIFont *newFont=[self.textLayer.font fontWithSize:currentSize];
            NSAttributedString *newString=[[NSAttributedString alloc] initWithString:self.textLayer.text attributes:[NSDictionary dictionaryWithObject:newFont forKey:NSFontAttributeName]];
            NSInteger numLines=ceil((newString.size.width*newString.size.height)/(self.textLayer.frame.size.width)/newFont.lineHeight);
            if(numLines*newFont.lineHeight>self.frame.size.height)
            {
                isTooBig=YES;
                currentSize-=1.0f;
            }
        }
        return currentSize;
    }
    else
    {
        CGFloat currentSize=1.0f;
        BOOL isTooBig=NO;
        while(!isTooBig)
        {
            currentSize+=1.0f;
            UIFont *newFont=[self.textLayer.font fontWithSize:currentSize];
            NSAttributedString *newString=[[NSAttributedString alloc] initWithString:self.textLayer.text attributes:[NSDictionary dictionaryWithObject:newFont forKey:NSFontAttributeName]];
            NSInteger numLines=ceil((newString.size.width*newString.size.height)/(self.textLayer.frame.size.width)/newFont.lineHeight);
            if(numLines*newFont.lineHeight>self.parentRect.size.height/2)
            {
                isTooBig=YES;
                currentSize-=1.0f;
            }
        }
        return currentSize;
    }
}

-(CGFloat)fontSize
{
    return _textLayer.font.pointSize;
}

-(void)fontSizeDidChangeTo:(CGFloat)fontSize
{
    [self.textLayer setFont:[self.textLayer.font fontWithSize:fontSize]];
    if(self.flexibleHeight)
    {
        [self resizeBoundingRect];
    }
    else
    {
        self.frame=self.frame;
    }
}

-(void)resizeBoundingRect
{
    NSInteger currentNumLines=ceil(_textLayer.attributedText.size.width*_textLayer.attributedText.size.height/self.frame.size.width/_textLayer.font.lineHeight);
    if(self.frame.size.height!=currentNumLines*_textLayer.font.lineHeight)
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, currentNumLines*_textLayer.font.lineHeight)];
    }
}

-(void)sizeToFit
{
    while(self.fontSize>self.maxTextSize)
    {
        [self fontSizeDidChangeTo:self.fontSize-1];
    }
}

@end
