//
//  textAlignmentPopupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textAlignmentPopupToolView.h"

@interface textAlignmentPopupToolView(){
    UISegmentedControl *segControl;
    
    NSTextAlignment ops[3];
    
    NSInteger selectedIndex;
}
@end

@implementation textAlignmentPopupToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self.slider removeFromSuperview];
    self.slider=nil;
    segControl=[[UISegmentedControl alloc] initWithItems:[self options]];
    CGFloat border=6;
    [segControl setFrame:CGRectMake(border, border, frame.size.width-border*2, frame.size.height-border*2)];
    //[segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segControl addTarget:self action:@selector(segmentEventOccured:) forControlEvents:UIControlEventAllEvents];
    [segControl setTintColor:[UIColor blackColor]];
    [self setops];
    [self addSubview:segControl];
    return self;
}

-(void)configureWithToolType:(popupType)type
{
    if(type==LTpopupBodyTextAlignmentTool)
    {
        self.responder=[[imageEditorView sharedInstance] bodyLayer];
    }
    else if(type==LTpopupTitleTextAlignmentTool)
    {
        self.responder=[[imageEditorView sharedInstance] titleLayer];
    }
    NSTextAlignment current=[self.responder textAlignment];
    for(NSInteger i=0; i<3; i++)
    {
        if(ops[i]==current)
        {
            [segControl setSelectedSegmentIndex:i];
            selectedIndex=i;
        }
    }
}

-(IBAction)segmentChanged:(UISegmentedControl*)sender
{
    [self.responder textAlignmentDidChangeTo:ops[[sender selectedSegmentIndex]]];
}

-(IBAction)segmentEventOccured:(UISegmentedControl*)sender
{
    [self.responder textAlignmentDidChangeTo:ops[[sender selectedSegmentIndex]]];
}

-(NSArray<NSString*>*)options
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Left"];
    [temp addObject:@"Center"];
    [temp addObject:@"Right"];
    return [NSArray arrayWithArray:temp];
}

-(void)setops
{
    ops[0]=NSTextAlignmentLeft;
    ops[1]=NSTextAlignmentCenter;
    ops[2]=NSTextAlignmentRight;
}

@end
