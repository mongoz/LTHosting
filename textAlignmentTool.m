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
    segControl=nil;
    segControl=[[UISegmentedControl alloc] initWithItems:@[@"Left",@"Center",@"Right"]];
    //[segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} forState:UIControlStateNormal];
    [segControl setBackgroundColor:[UIColor clearColor]];
    [segControl setTintColor:[UIColor blackColor]];
    [self addSubview:segControl];
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} forState:UIControlStateNormal];
    [segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat marginx=24.0f;
    CGFloat height=self.frame.size.height/3;
    [segControl setFrame:CGRectMake(marginx, self.bounds.size.height/2-height/2, self.bounds.size.width-marginx*2, height)];
    [self layoutIfNeeded];
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

@end
