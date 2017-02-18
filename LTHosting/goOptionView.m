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
    CGFloat margin=self.barView.frame.size.height/5;
    UIButton *goButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.barView.frame.size.width/self.barView.frame.size.height)*self.barView.frame.size.height-margin*2, self.barView.frame.size.height-margin*2)];
    [goButton setCenter:self.barView.center];
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton setBackgroundColor:[UIColor flatMintColor]];
    [goButton.layer setCornerRadius:goButton.frame.size.height/2];
    [goButton.layer setMasksToBounds:YES];
    [goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventTouchDown];
    [goButton setShowsTouchWhenHighlighted:YES];
    self.barView.layer.shadowOpacity=0.0f;
    goButton.showsTouchWhenHighlighted=NO;
    [self.barView addSubview:goButton];
}

-(IBAction)goPressed:(UIButton*)sender
{
    CALayer *highlightLayer=[CALayer layer];
    [highlightLayer setFrame:sender.bounds];
    [highlightLayer setCornerRadius:sender.layer.cornerRadius];
    [highlightLayer setBackgroundColor:[UIColor whiteColor].CGColor];
    [highlightLayer setOpacity:0.0f];
    [sender.layer addSublayer:highlightLayer];
    [UIView animateWithDuration:.25 animations:^{
        [highlightLayer setOpacity:0.5f];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.25 animations:^{
            [highlightLayer setOpacity:0.0f];
        } completion:^(BOOL finished){
            [highlightLayer removeFromSuperlayer];
            [self.myDelegate goWasPressed];
        }];
    }];
    
}

@end
