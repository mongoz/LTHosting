//
//  sizeTool.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/28/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "sizeTool.h"
#import "textEditingLayer.h"

@interface sizeTool(){
    UISlider *mySlider;
    
    NSDate *lastUpdate;
}

@end

@implementation sizeTool

-(id)init
{
    self=[super init];
    mySlider=nil;
    lastUpdate=[NSDate date];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat margin=24;
    if(frame.size.height>0&&frame.size.width>0)
    {
        if(mySlider==nil)
        {
            mySlider=[[UISlider alloc] initWithFrame:CGRectMake(margin, margin, self.bounds.size.width-margin*2, self.bounds.size.height-margin*2)];
            [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            mySlider.minimumValue=8.0f;
            mySlider.maximumValue=[(textEditingLayer*)self.targetLayer maxTextSize];
            [self addSubview:mySlider];
            [self layoutIfNeeded];
        }
    }
}

-(IBAction)sliderValueChanged:(UISlider*)slider
{
    if([[NSDate date] timeIntervalSinceDate:lastUpdate]>.05f||slider.value==slider.maximumValue)
    {
        [(textEditingLayer*)self.targetLayer setFont:[[(textEditingLayer*)self.targetLayer font] fontWithSize:slider.value]];
        lastUpdate=[NSDate date];
    }
}

-(void)updateCurrentValueAnimated:(BOOL)animated
{
    [super updateCurrentValueAnimated:animated];
    [mySlider setValue:[self currentValue] animated:animated];
}

-(CGFloat)currentValue
{
    return [(textEditingLayer*)self.targetLayer font].pointSize;
}

@end
