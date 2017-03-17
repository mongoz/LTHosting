//
//  commentAddView.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "commentAddView.h"
#import "commentAddContainer.h"
#import "commentsHeaderView.h"

@interface commentAddView(){
    CGRect initialFrame;
    UITextView *field;
    UIButton *cameraButton;
    BOOL layoutEditing;
}

@end

@implementation commentAddView

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
    _container=nil;
    layoutEditing=NO;
    self.layer.borderColor=[UIColor redColor].CGColor;
    self.layer.borderWidth=2.0f;
    self.backgroundColor=[UIColor whiteColor];
    field=[[UITextView alloc] init];
    field.autocorrectionType=UITextAutocorrectionTypeNo;
    field.userInteractionEnabled=NO;
    [field setText:@"Add Comment"];
    field.textColor=[UIColor lightGrayColor];
    field.font=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    cameraButton=[[UIButton alloc] init];
    [cameraButton addTarget:self action:@selector(cameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.layer.backgroundColor=[UIColor blackColor].CGColor;
    [self addSubview:cameraButton];
    [self addSubview:field];
    return self;
}

-(void)cameraPressed:(UIButton*)cameraButton{
    [self.home.transitionController showImagePicker];
}

-(id)initWithUser:(user *)someUser
{
    self=[self init];
    _poster=someUser;
    return self;
}

-(id)initWithFrame:(CGRect)frame user:(user *)someUser
{
    self=[self initWithFrame:frame];
    _poster=someUser;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(!layoutEditing)
    {
        CGFloat margin=8.0f;
        CGFloat height=self.frame.size.height-margin*2;
        cameraButton.frame=CGRectMake(margin, margin, height, height);
        field.frame=CGRectMake(cameraButton.frame.origin.x+cameraButton.frame.size.width+margin, margin, self.frame.size.width-margin-(cameraButton.frame.origin.x+cameraButton.frame.size.width+margin), height);
        cameraButton.layer.cornerRadius=height/2;
    }
    else
    {
        field.frame=self.bounds;
    }
}

-(void)beginEditingWithCompletion:(void (^)())completionBlock
{
    initialFrame=self.frame;
    layoutEditing=YES;
    self.frame=self.frame;
    [UIView animateWithDuration:.15 animations:^{
        cameraButton.alpha=0;
        field.text=@"";
    }completion:^(BOOL finished){
        field.userInteractionEnabled=YES;
        field.textColor=[UIColor blackColor];
        field.selectedRange=NSMakeRange(0, 0);
        [self becomeFirstResponder];
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}

-(void)endEditingWithCompletion:(void (^)())completionBlock
{
    [self endEditing:YES];
    field.userInteractionEnabled=NO;
    [UIView animateWithDuration:.25 animations:^{
        self.frame=initialFrame;
    } completion:^(BOOL finished){
        layoutEditing=NO;
        self.frame=self.frame;
        [UIView animateWithDuration:.25 animations:^{
            cameraButton.alpha=1.0f;
            field.text=@"Add Comment";
            field.textColor=[UIColor lightGrayColor];
        } completion:^(BOOL finished){
            if(completionBlock!=nil){
                completionBlock();
            }
        }];
    }];
}

-(UIView*)textViewAccessoryView
{
    CGFloat topHeight=1.0f;
    UIView *container=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44+topHeight)];
    container.backgroundColor=[UIColor whiteColor];
    CGFloat margin=4.0f;
    CGFloat height=container.frame.size.height-margin*2;
    UIButton *sendButton=[[UIButton alloc] initWithFrame:CGRectMake(container.frame.size.width-margin-height*1.618f, margin+topHeight, height*1.618f, height)];
    [sendButton addTarget:self action:@selector(sendTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendTouchDown:) forControlEvents:UIControlEventTouchDown];
    [sendButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpOutside];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    sendButton.backgroundColor=[UIColor blueColor];
    sendButton.layer.borderColor=[UIColor blueColor].CGColor;
    sendButton.layer.borderWidth=2.0f;
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    sendButton.tintColor=[UIColor whiteColor];
    sendButton.layer.cornerRadius=margin*2.0f;
    sendButton.layer.masksToBounds=YES;
    [container addSubview:sendButton];
    UIView *top=[[UIView alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, topHeight)];
    top.backgroundColor=[UIColor blackColor];
    [container addSubview:top];
    return container;
}

-(void)sendTouchUp:(UIButton*)sendButton
{
    if(_container!=nil)
    {
        [_container sendTapped];
    }
}

-(void)sendUp:(UIButton*)sendButton
{
    sendButton.backgroundColor=[UIColor blueColor];
    sendButton.tintColor=[UIColor whiteColor];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)sendTouchDown:(UIButton*)sendButton
{
    sendButton.backgroundColor=[UIColor whiteColor];
    sendButton.tintColor=[UIColor blueColor];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

-(BOOL)becomeFirstResponder
{
    if(field.inputAccessoryView==nil)
    {
        field.inputAccessoryView=[self textViewAccessoryView];
    }
    return [field becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return [field canBecomeFirstResponder];
}

-(BOOL)endEditing:(BOOL)force
{
    return [field endEditing:force];
}

-(void)endEditing
{
    
}

-(BOOL)resignFirstResponder
{
    return [field resignFirstResponder];
}

@end
