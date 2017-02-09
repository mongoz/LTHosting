//
//  switchOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "switchOptionView.h"

@interface switchOptionView(){
    eventOptionSwitchType type;
    
    UISwitch *swap;
    
    UILabel *left;
    
    UILabel *right;
}
@end

@implementation switchOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame type:(eventOptionSwitchType)typ barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    type=typ;
    [self configureBarView];
    return self;
}

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    type=LTswitchOptionFree;
    [self configureBarView];
    return self;
}

-(BOOL)hasAccessoryView
{
    return NO;
}

-(void)configureBarView
{
    CGFloat margin=8;
    left=[[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.barView.bounds.size.width/2-margin, self.barView.bounds.size.height-margin*2)];
    right=[[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width+margin, margin, left.frame.size.width, left.frame.size.height)];
    [right setTextAlignment:NSTextAlignmentRight];
    if(type==LTswitchOptionFree)
    {
        left.text=@"Free";
        right.text=@"Paid";
    }
    else if(type==LTswitchOptionPrivate)
    {
        left.text=@"Private";
        right.text=@"Public";
    }
    [left setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [right setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    
    swap=[[UISwitch alloc] initWithFrame:self.barView.bounds];
    [swap setFrame:CGRectMake(self.barView.frame.size.width/2-swap.frame.size.width/2, self.barView.frame.size.height/2-swap.frame.size.height/2, swap.frame.size.width, swap.frame.size.height)];
    
    [self.barView addSubview:swap];
    [self.barView addSubview:left];
    [self.barView addSubview:right];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate=self;
    [self.barView addGestureRecognizer:tap];
    [self updateFonts];
}

-(void)updateFonts
{
    void (^switchBlock)(UILabel*, UILabel*)=^(UILabel *off, UILabel *on){
        [UIView animateWithDuration:25 animations:^{
            [on setFont:[UIFont boldSystemFontOfSize:on.font.pointSize]];
            [off setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
        } completion:^(BOOL finished){
        }];
    };
    if([swap isOn])
    {
        switchBlock(left, right);
    }
    else
    {
        switchBlock(right, left);
    }
}

-(IBAction)tap
{
    [swap setOn:!swap.isOn animated:YES];
    [self updateFonts];
}

-(eventOptionSwitchType)isToolType
{
    return type;
}

-(void)detailEditingWillEnd
{
    if(type==LTswitchOptionFree)
    {
        [[event sharedInstance] setIsFree:!swap.isOn];
    }
    else if(type==LTswitchOptionPrivate)
    {
        [[event sharedInstance] setIsPrivate:!swap.isOn];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
