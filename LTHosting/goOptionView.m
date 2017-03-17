//
//  goOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "goOptionView.h"

@implementation goOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    [self configureBarView];
    return self;
}

-(BOOL)hasAccessoryView
{
    return NO;
}

-(void)configureBarView
{
    CGFloat margin=4.0f;
    CGFloat height=self.barView.frame.size.height-margin*2;
    UIButton *goButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [goButton setCenter:self.barView.center];
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButton setBackgroundColor:[UIColor flatGreenColor]];
    goButton.layer.borderColor=goButton.backgroundColor.CGColor;
    goButton.layer.borderWidth=2.0f;
    [goButton.layer setCornerRadius:goButton.frame.size.height/2];
    [goButton.layer setMasksToBounds:YES];
    [goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventTouchUpInside];
    [goButton addTarget:self action:@selector(goTouchDown:) forControlEvents:UIControlEventTouchDown];
    [goButton addTarget:self action:@selector(goTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [goButton addTarget:self action:@selector(goTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [goButton setShowsTouchWhenHighlighted:YES];
    self.barView.layer.shadowOpacity=0.0f;
    goButton.showsTouchWhenHighlighted=NO;
    [self.barView addSubview:goButton];
}

-(void)goTouchDown:(UIButton*)goButton
{
    [self swapButtonColors:goButton];
}

-(void)goTouchUp:(UIButton*)goButton
{
    [self swapButtonColors:goButton];
}

-(void)swapButtonColors:(UIButton*)button
{
    UIColor *title=button.currentTitleColor;
    [button setTitleColor:button.backgroundColor forState:UIControlStateNormal];
    button.backgroundColor=title;
}

-(IBAction)goPressed:(UIButton*)sender
{
    if(self.myDelegate!=nil)
    {
        [self.myDelegate goWasPressed];
    }
}

-(BOOL)isComplete
{
    return YES;
}

-(NSString*)optionName
{
    return @"Go";
}

@end
