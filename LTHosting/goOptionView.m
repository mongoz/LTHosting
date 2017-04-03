//
//  goOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "goOptionView.h"
#import "usefulArray.h"
#import "cblock.h"

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
    CGFloat height=64.0f;
    UIButton *goButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [goButton setCenter:self.barView.center];
    [goButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"GO" attributes:@{NSFontAttributeName:[usefulArray titleFontsWithSize:32.0f].firstObject,NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [goButton setBackgroundColor:[UIColor flatLimeColor]];
    goButton.layer.borderColor=[UIColor blackColor].CGColor;
    goButton.layer.borderWidth=2.0f;
    [goButton.layer setCornerRadius:goButton.frame.size.height/2];
    [goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventTouchUpInside];
    [goButton addTarget:self action:@selector(goTouchDown:) forControlEvents:UIControlEventTouchDown];
    [goButton addTarget:self action:@selector(goTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [goButton addTarget:self action:@selector(goTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [goButton setShowsTouchWhenHighlighted:YES];
    goButton.layer.shadowColor=[UIColor blackColor].CGColor;
    goButton.layer.shadowRadius=4.0f;
    goButton.layer.shadowOpacity=0.0f;
    goButton.layer.shadowOffset=CGSizeZero;
    self.barView.layer.shadowOpacity=0.0f;
    goButton.showsTouchWhenHighlighted=NO;
    [self.barView addSubview:goButton];
}

-(void)goTouchDown:(UIButton*)goButton
{
    [goButton setBackgroundColor:[UIColor flatLimeColorDark]];
    [goButton setAttributedTitle:[cblock make:^id{
        NSMutableAttributedString *s=[[NSMutableAttributedString alloc] initWithAttributedString:goButton.currentAttributedTitle];
        NSRange full=NSMakeRange(0, s.length);
        [s removeAttribute:NSForegroundColorAttributeName range:full];
        [s addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:full];
        return s;
    }] forState:UIControlStateNormal];
    goButton.layer.shadowOpacity=.5f;
}

-(void)goTouchUp:(UIButton*)goButton
{
    [goButton setBackgroundColor:[UIColor flatLimeColor]];
    [goButton setAttributedTitle:[cblock make:^id{
        NSMutableAttributedString *s=[[NSMutableAttributedString alloc] initWithAttributedString:goButton.currentAttributedTitle];
        NSRange full=NSMakeRange(0, s.length);
        [s removeAttribute:NSForegroundColorAttributeName range:full];
        [s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:full];
        return s;
    }] forState:UIControlStateNormal];
    goButton.layer.shadowOpacity=0.0f;
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
