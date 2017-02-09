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
    for(UIView *v in self.barView.subviews)
    {
        [v removeFromSuperview];
    }
    self.barView.backgroundColor=[UIColor clearColor];
    CGFloat margin=self.barView.frame.size.height/5;
    UIButton *goButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.barView.frame.size.width/self.barView.frame.size.height)*self.barView.frame.size.height-margin*2, self.barView.frame.size.height-margin*2)];
    [goButton setCenter:self.barView.center];
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton setBackgroundColor:[UIColor greenColor]];
    [goButton.layer setCornerRadius:goButton.frame.size.height/2];
    [goButton.layer setMasksToBounds:YES];
    [goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [goButton setShowsTouchWhenHighlighted:YES];
    self.barView.layer.shadowOpacity=0.0f;
    [self.barView addSubview:goButton];
}

-(IBAction)goPressed:(UIButton*)sender
{
    [self.myDelegate goWasPressed];
}

@end
