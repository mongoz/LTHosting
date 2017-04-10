//
//  textAlignmentTool.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textAlignmentTool.h"
#import "textEditingLayer.h"

@interface textAlignmentTool(){
    UISegmentedControl *segControl;
}

@end

@implementation textAlignmentTool

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
    
    return self;
}

-(void)segmentChanged:(UISegmentedControl*)control
{
    switch(control.selectedSegmentIndex)
    {
        case 0:
            [(textEditingLayer*)self.targetLayer setTextAlignment:NSTextAlignmentLeft];
            break;
        case 1:
            [(textEditingLayer*)self.targetLayer setTextAlignment:NSTextAlignmentCenter];
            break;
        case 2:
            [(textEditingLayer*)self.targetLayer setTextAlignment:NSTextAlignmentRight];
            break;
        default:
            break;
    }
}

-(void)updateCurrentValueAnimated:(BOOL)animated
{
    if(segControl==nil){
        return;
    }
    [super updateCurrentValueAnimated:animated];
    switch([(textEditingLayer*)self.targetLayer textAlignment])
    {
        case NSTextAlignmentLeft:
            segControl.selectedSegmentIndex=0;
            break;
        case NSTextAlignmentCenter:
            segControl.selectedSegmentIndex=1;
            break;
        case NSTextAlignmentRight:
            segControl.selectedSegmentIndex=2;
            break;
        default:
            break;
    }
}

-(void)toolWillAppear{
    [super toolWillAppear];
    CGFloat marginx=24.0f;
    CGFloat height=self.frame.size.height/3;
    segControl=[[UISegmentedControl alloc] initWithItems:@[@"Left",@"Center",@"Right"]];
    [segControl setBackgroundColor:[UIColor clearColor]];
    [segControl setTintColor:[UIColor blackColor]];
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} forState:UIControlStateNormal];
    segControl.frame=CGRectMake(marginx, self.bounds.size.height/2-height/2, self.bounds.size.width-marginx*2, height);
    [segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segControl];
    
    [self updateCurrentValueAnimated:NO];
}

@end
