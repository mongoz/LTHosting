//
//  tool.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "tool.h"
#import "borderPicker.h"
#import "colorTool.h"
#import "shadeTool.h"
#import "sizeTool.h"
#import "fontTool.h"
#import "textAlignmentTool.h"
#import "backgroundTintTool.h"

@interface tool(){
    __weak editingLayer *targetLayer;
}

@end

@implementation tool

@synthesize targetLayer;

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
    targetLayer=nil;
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return self;
}

-(id)initWithTarget:(editingLayer *)target skew:(toolSkew)skew
{
    switch (skew) {
        case borderPickerTool:
            self=[[borderPicker alloc] init];
            break;
        case colorPickerTool:
            self=[[colorTool alloc] init];
            break;
        case shadePickerTool:
            self=[[shadeTool alloc] init];
            break;
        case sizePickerTool:
            self=[[sizeTool alloc] init];
            break;
        case fontPickerTool:
            self=[[fontTool alloc] init];
            break;
        case alignmentTool:
            self=[[textAlignmentTool alloc] init];
            break;
        case tintTool:
            self=[[backgroundTintTool alloc] init];
            break;
        default:
            self=[self init];
            break;
    }
    self.targetLayer=target;
    return self;
}

-(id)initWithFrame:(CGRect)frame target:(editingLayer *)target skew:(toolSkew)skew
{
    self=[self initWithTarget:target skew:skew];
    self.frame=frame;
    [self layoutIfNeeded];
    return self;
}

-(void)dissolveIn:(BOOL)comingIn completion:(void (^)())completionBlock
{
    CGFloat alph=0;
    if(comingIn)
    {
        alph=1;
        [self updateCurrentValueAnimated:NO];
    }
    [UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.hidden=!comingIn;
    }completion:^(BOOL finished){
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}

-(void)updateCurrentValueAnimated:(BOOL)animated
{
    
}

-(BOOL)isHidden
{
    return self.alpha==0.0f;
}

-(void)setHidden:(BOOL)hidden
{
    if(hidden)
    {
        self.alpha=0.0f;
    }
    else
    {
        self.alpha=1.0f;
    }
}

-(void)toolDidLoad{
    
}

-(void)toolWillAppear{
    
}

@end
