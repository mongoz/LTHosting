//
//  toolViewItem.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "toolViewItem.h"
#import "tool.h"
#import "toolView.h"


@interface toolViewItem(){
    toolSkew mySkew;
    editingLayer *myTarget;
    
    UIImageView *imageView;
    UILabel *label;
    
}

@end

@implementation toolViewItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self=[super init];
    myTarget=nil;
    imageView=[[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    label=[[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    label.adjustsFontSizeToFitWidth=NO;
    [self addSubview:imageView];
    [self addSubview:label];
    [self setSelectable:YES];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    CGFloat scale=self.frame.size.height/frame.size.height;
    [super setFrame:frame];
    CGFloat verticalLayoutConstant=self.bounds.size.height/3;
    CGRect imageViewFrame=CGRectMake((self.bounds.size.width-verticalLayoutConstant)/2, verticalLayoutConstant/2, verticalLayoutConstant, verticalLayoutConstant);
    CGRect labelFrame=CGRectMake(0, imageViewFrame.origin.y+imageViewFrame.size.height+verticalLayoutConstant/2, self.bounds.size.width, verticalLayoutConstant/2);
    [imageView setFrame:imageViewFrame];
    [label setFrame:labelFrame];
    if(scale!=0)
    {
        [label setFont:[label.font fontWithSize:label.font.pointSize/scale]];
    }
    [self layoutIfNeeded];
}

-(id)initWithSkew:(toolSkew)skew target:(editingLayer*)target
{
    self=[self init];
    mySkew=skew;
    myTarget=target;
    [self configure];
    return self;
}

-(void)setButtonDelegate:(id<buttonTouchDelegate>)del
{
    [self addTarget:del action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:del action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:del action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)configure
{
    label.hidden=YES;
    [label setAttributedText:[[NSAttributedString alloc] initWithString:[self lText]]];
    label.hidden=NO;
    [imageView setImage:[self image]];
}

-(NSString*)lText
{
    switch(mySkew)
    {
        case borderPickerTool:
            return @"Border";
        case colorPickerTool:
            return @"Color";
        case shadePickerTool:
            return @"Shade";
        case sizePickerTool:
            return @"Size";
        case fontPickerTool:
            return @"Font";
        case alignmentTool:
            return @"Alignment";
        default:
            return @"";
    }
}

UIImage *myImage=nil;

-(UIImage*)image
{
    if(myImage==nil)
    {
        myImage=[UIImage imageNamed:@"test3.png"];
    }
    return myImage;
}

-(void)setImage:(UIImage *)image
{
    myImage=image;
}

-(tool*)correspondingTool
{
    return [[tool alloc] initWithTarget:myTarget skew:mySkew];
}

BOOL isSelectable=YES;

-(BOOL)selectable
{
    return isSelectable;
}

-(void)setSelectable:(BOOL)selectable
{
    isSelectable=selectable;
    if(isSelectable)
    {
        [self setAlpha:1.0f];
    }
    
    else
    {
        [self setAlpha:0.5f];
    }
    [self setUserInteractionEnabled:isSelectable];
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    if(userInteractionEnabled==isSelectable)
    {
        [super setUserInteractionEnabled:userInteractionEnabled];
    }
}

-(UIFont*)labelFont
{
    return label.font;
}

-(void)setLabelFont:(UIFont *)labelFont
{
    label.font=labelFont;
}

@end
