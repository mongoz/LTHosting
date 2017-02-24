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
        default:
            self=[self init];
            break;
    }
    targetLayer=target;
    return self;
}

-(id)initWithFrame:(CGRect)frame target:(editingLayer *)target skew:(toolSkew)skew
{
    self=[self initWithTarget:target skew:skew];
    [self setFrame:frame];
    return self;
}

-(void)dissolveIn:(BOOL)comingIn completion:(void (^)())completionBlock
{
    [UIView transitionWithView:self duration:.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.hidden=!comingIn;
    }completion:^(BOOL finished){
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}

@end
