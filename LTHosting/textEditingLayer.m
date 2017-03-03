//
//  textEditingLayer.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textEditingLayer.h"
#import "smarterString.h"
#import "editorView.h"

@interface textEditingLayer(){
    BOOL flexibleHeight;
    CGFloat textScale;
    BOOL frameChanged;
    CGFloat maxSize;
}

@end

@implementation textEditingLayer

-(id)init
{
    self=[super init];
    _textLabel=[[CATextLayer alloc] init];
    _textLabel.foregroundColor=[self defaultTextColor].CGColor;
    _textLabel.shadowColor=[UIColor blackColor].CGColor;
    _textLabel.shadowOpacity=0.5f;
    _textLabel.shadowOffset=CGSizeZero;
    [_textLabel setBackgroundColor:[UIColor clearColor].CGColor];
    _textLabel.font=[self CGFontFromUIFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    _textLabel.rasterizationScale=5.0f;
    _textLabel.contentsScale=[[UIScreen mainScreen] scale];
    _textLabel.alignmentMode=kCAAlignmentLeft;
    [_textLabel setWrapped:YES];
    [self addSublayer:_textLabel];
    flexibleHeight=NO;
    self.masksToBounds=NO;
    maxSize=0;
    frameChanged=YES;
    return self;
}

-(UIColor*)defaultTextColor
{
    return [UIColor whiteColor];
}

-(void)setFrame:(CGRect)frame
{
    frameChanged=YES;
    [super setFrame:frame];
    [self setLabelFrame];
}


-(void)setLabelFrame
{
    [_textLabel setFrame:[self boundingRect]];
    if(self.flexibleHeight)
    {
        CGFloat height=[self.attributedText numberOfLinesRequiredForLineWidth:self.bounds.size.width]*self.font.lineHeight;
        height*=1.01f;
        [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _textLabel.frame.size.width, height)];
    }
    else if(self.font.pointSize>[self maxTextSize])
    {
        [self setFont:[self.font fontWithSize:[self maxTextSize]]];
    }
}


-(CGFloat)maxTextSize
{
    if(frameChanged)
    {
        CGRect boundingRect=[self boundingRect];
        NSString *myString=_textLabel.string;
        if(myString.length<1)
        {
            return 1.0f;
        }
        CGFloat fontSize=0.0f;
        UIFont *myFont=self.font;
        BOOL bigEnough=NO;
        while(!bigEnough)
        {
            fontSize+=1.0f;
            myFont=[myFont fontWithSize:fontSize];
            NSAttributedString *attString=[[NSAttributedString alloc] initWithString:myString attributes:[NSDictionary dictionaryWithObject:myFont forKey:NSFontAttributeName]];
            CGFloat neededHeight=[attString numberOfLinesRequiredForLineWidth:boundingRect.size.width]*myFont.lineHeight*1.1f;
            if(neededHeight>boundingRect.size.height)
            {
                fontSize-=1.0f;
                bigEnough=YES;
            }
        }
        maxSize=fontSize;
        frameChanged=NO;
    }
    return MAX(maxSize,1.0f);
}

-(void)autoAdjustFontSize
{
    [self setFont:[self.font fontWithSize:[self maxTextSize]]];
}

-(void)setFont:(UIFont*)font
{
    if([self CGFontFromUIFont:font]!=_textLabel.font)
    {
        [_textLabel setFont:[self CGFontFromUIFont:font]];
        frameChanged=YES;
    }
    if(font.pointSize!=_textLabel.fontSize)
    {
        [_textLabel setFontSize:font.pointSize];
        _textLabel.shadowRadius=font.pointSize/10.0f;
    }
    if(!([self.text isEqualToString:@""]||self.text==nil))
    {
        if([self maxTextSize]<self.font.pointSize)
        {
            [self setFont:[self.font fontWithSize:[self maxTextSize]]];
        }
    }
    [self setLabelFrame];
}

-(CGFontRef)CGFontFromUIFont:(UIFont*)font
{
    return CGFontCreateWithFontName((CFStringRef)font.fontName);
}

-(UIFont*)UIFontFromCGFont:(CGFontRef)font withSize:(CGFloat)size
{
    NSString *fontName=(NSString*)CFBridgingRelease(CGFontCopyPostScriptName(font));
    return [UIFont fontWithName:fontName size:size];
    
}

-(UIFont*)font
{
    return [self UIFontFromCGFont:(CGFontRef)_textLabel.font withSize:_textLabel.fontSize];
}

-(CGRect)boundingRect
{
    if(!self.flexibleHeight||self.superlayer==nil)
    {
        return self.bounds;
    }
    CGRect parentRect=[[editorView shared] borderLayer].bounds;
    return CGRectMake(0, 0, parentRect.size.width-self.frame.origin.y*2.0f, parentRect.size.height/1.618);
}

-(BOOL)flexibleHeight
{
    return flexibleHeight;
}

-(void)setFlexibleHeight:(BOOL)flexibleHeighta
{
    flexibleHeight=flexibleHeighta;
}

-(NSString*)text
{
    if(_textLabel.string==nil)
    {
        return @"";
        
    }
    return _textLabel.string;
}

-(NSAttributedString*)attributedText
{
    return [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
}

-(void)setText:(NSString *)text
{
    [_textLabel setString:text];
    [self setFont:self.font];
}

-(void)setColor:(UIColor *)color
{
    if(color==[UIColor clearColor])
    {
        [self setColor:[self defaultTextColor]];
        return;
    }
    _textLabel.foregroundColor=color.CGColor;
    CGFloat r,g,b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    _textLabel.shadowColor=[UIColor colorWithRed:1.0f-r green:1.0f-g blue:1.0f-b alpha:1.0f].CGColor;
}

-(UIColor*)color
{
    return [UIColor colorWithCGColor:_textLabel.foregroundColor];
}

-(NSTextAlignment)textAlignment
{
    if([_textLabel.alignmentMode isEqualToString:kCAAlignmentLeft])
    {
        return NSTextAlignmentLeft;
    }
    if([_textLabel.alignmentMode isEqualToString:kCAAlignmentCenter])
    {
        return NSTextAlignmentCenter;
    }
    return NSTextAlignmentRight;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    switch(textAlignment)
    {
        case NSTextAlignmentLeft:
            _textLabel.alignmentMode=kCAAlignmentLeft;
            break;
        case NSTextAlignmentCenter:
            _textLabel.alignmentMode=kCAAlignmentCenter;
            break;
        case NSTextAlignmentRight:
            _textLabel.alignmentMode=kCAAlignmentRight;
            break;
        default:
            break;
    }
}

@end
