//
//  popupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "popupToolView.h"
#import "imageEditorView.h"

@interface popupToolView(){
    
    CGFloat inset;
    
    CGRect fullFrame;
    
    BOOL hasPopped;
    
    void (^commitChange)(CGFloat, id<popupToolResponder>);
}
@end

@implementation popupToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    NSLog(@"init");
    fullFrame=frame;
    inset=8;
    
    self=[super initWithFrame:frame];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.layer setCornerRadius:5];
    
    _slider=[self aslider];
    //[self addSubview:[self okButton]];
    [self addSubview:_slider];
    [self setAutoresizesSubviews:NO];
    [self setFrame:CGRectMake(frame.origin.x+frame.size.width/2, frame.origin.y, 0, frame.size.height)];
    [self setAlpha:0];
    [self setUserInteractionEnabled:YES];
    hasPopped=NO;
    
    return self;
}

-(IBAction)testing:(id)sender
{
    [self popOutOfView];
    [_controller.toolBar setSelectedSegmentIndex:-1];
}

-(UISlider*)aslider
{
    UISlider *new=[[UISlider alloc] init];
    [new setFrame:CGRectMake(inset, inset, self.frame.size.width-2*inset, [self okButton].frame.size.height)];
    [new setUserInteractionEnabled:YES];
    [new setContinuous:YES];
    [new setMinimumValue:1];
    [new setMaximumValue:20];
    
    [new addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    //UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderChanged:)];
    //[new addGestureRecognizer:tap];
    return new;
}


-(IBAction)sliderChanged:(UISlider*)aslider
{
    commitChange([aslider value],_responder);
}

-(UIButton*)okButton
{
    UIButton *new=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-inset-self.frame.size.height-2*inset, inset, self.frame.size.height-2*inset, self.frame.size.height-2*inset)];
    [new setTitle:@"OK" forState:UIControlStateNormal];
    [new.titleLabel setTextColor:[UIColor blackColor]];
    [new setUserInteractionEnabled:YES];
    [new setShowsTouchWhenHighlighted:YES];
    [new setExclusiveTouch:YES];
    [new setHighlighted:YES];
    return new;
}

-(void)popIntoView
{
    NSLog(@"pop in");
    if(hasPopped)
    {
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        [self setFrame:fullFrame];
        [self setAlpha:1.0f];
    } completion:^(BOOL finished){
        hasPopped=YES;
        [self becomeFirstResponder];
    }];
}

-(void)popOutOfView
{
    NSLog(@"pop out");
    if(!hasPopped)
    {
        return;
    }
    CGRect newFrame=CGRectMake(fullFrame.origin.x+fullFrame.size.width/2, fullFrame.origin.y, 0, fullFrame.size.height);
    [UIView animateWithDuration:.5 animations:^{
        [self setFrame:newFrame];
        [self setAlpha:0];
        [_controller setIsUsingTool:NO];
    } completion:^(BOOL finished){
        _responder=nil;
        _controller=nil;
        [self removeFromSuperview];
    }];
}

-(void)configureWithToolType:(popupType)type
{
    _type=type;
    _responder=[[imageEditorView sharedInstance] selectedLayer];
    switch (type) {
        case LTpopupBorderWidthTool:{
            commitChange=^(CGFloat num, id<popupToolResponder> respond){
                [respond borderWidthDidChangeTo:num];
            };
            [_slider setValue:[_responder borderWidth]];
            [_slider setMaximumValue:100];
            break;}
        case LTpopupCornerRadiusTool:{
            commitChange=^(CGFloat num, id<popupToolResponder> respond){
                [respond cornerRadiusDidChangeTo:num];
            };
            [_slider setValue:[_responder cornerRadius]];
            [_slider setMaximumValue:100];
            break;}
        default:{
            
            break;}
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"set frame: %f, %f, %f, %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

@end
