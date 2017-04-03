//
//  eventOptionVIew.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionVIew.h"
#import "stackView.h"

@interface eventOptionView(){
    
    BOOL accessoryShowing;
    BOOL red;
    CGFloat barHeight;
    UIColor *naturalBackgroundColor;
}
@end

@implementation eventOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

BOOL hasAddedBaseline=NO;

-(id)initWithFrame:(CGRect)frame
{
    self=[self initWithFrame:frame barHeight:60];
    return self;
}

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeigh
{
    self=[super initWithFrame:frame];
    red=NO;
    barHeight=barHeigh;
    accessoryShowing=NO;
    _barView=[self defaultBarView];
    [self insertArrangedSubview:_barView atIndex:0];
    _myDelegate=nil;
    _accessoryView=nil;
    self.axis=UILayoutConstraintAxisVertical;
    self.distribution=UIStackViewDistributionFill;
    self.alignment=UIStackViewAlignmentFill;
    return self;
}

-(UIView*)defaultBarView
{
    stackView *new=[[stackView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, barHeight)];;
    [new setBackgroundColor:[UIColor whiteColor]];
    CGFloat width=0.5f;
    UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, new.frame.size.height-width, new.frame.size.width, width)];
    [bottom setBackgroundColor:[UIColor blackColor]];
    [new addSubview:bottom];
    UIView *top=[[UIView alloc] initWithFrame:CGRectMake(0, 0, new.frame.size.width, width)];
    [top setBackgroundColor:[UIColor blackColor]];
    [new addSubview:top];
    [new addSubview:bottom];
    [new.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [new.layer setShadowRadius:8.0f];
    [new.layer setShadowOpacity:.5f];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [new addGestureRecognizer:tap];
    tap.delegate=self;
    return new;
}

-(BOOL)red{
    return red;
}

-(void)setRed:(BOOL)r{
    if(r!=red){
        red=r;
        red?[self makeRed]:[self unMakeRed];
    }
}

-(void)makeRed{
    naturalBackgroundColor=self.barView.backgroundColor;
    [self.barView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5f]];
}

-(void)unMakeRed{
    [self.barView setBackgroundColor:naturalBackgroundColor];
}

-(IBAction)tapped:(id)sender{
    [self tapBar];
}

-(BOOL)hasAccessoryView
{
    return _accessoryView!=nil;
}

-(BOOL)isAccessoryViewShowing
{
    return accessoryShowing;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)tapBar
{
    if(self.hasAccessoryView)
    {
        if(_myDelegate!=nil)
        {
            [_myDelegate accessoryShowingWillChangeForEventOptionView:self];
        }
        [UIView animateWithDuration:.25 animations:^{
            _accessoryView.hidden=!_accessoryView.hidden;
        } completion:^(BOOL finished){
            accessoryShowing=!_accessoryView.hidden;
            [self barTouched];
            if(_myDelegate!=nil)
            {
                [_myDelegate accessoryShowingDidChangeForEventOptionView:self];
            }
        }];
        
    }
    else{
        [self barTouched];
    }
}

-(void)barTouched{
    
}

-(void)setBarHeight:(CGFloat)barHeigh
{
    barHeight=barHeigh;
    if(_barView!=nil)
    {
        [_barView removeFromSuperview];
        
    }
}

-(CGFloat)barHeight
{
    return barHeight;
}

-(UIView*)inputAccessoryView
{
    UIView *test=[[UIView alloc] initWithFrame:self.barView.frame];
    [test setBackgroundColor:[UIColor blackColor]];
    return nil;
}

-(void)detailEditingWillEnd
{
    
}

-(NSString*)optionName
{
    return @"Option";
}

-(BOOL)isComplete
{
    return YES;
}

@end
