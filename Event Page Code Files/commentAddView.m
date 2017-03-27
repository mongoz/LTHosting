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
#import "LTTextView.h"

@interface commentAddView(){
    CGRect initialFrame;
    LTTextView *field;
    UIButton *cameraButton;
    BOOL layoutEditing;
    NSString *commentText;
    UIView *bottom;
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
    commentText=@"";
    _container=nil;
    layoutEditing=NO;
    bottom=[[UIView alloc] init];
    [self addSubview:bottom];
    bottom.backgroundColor=[UIColor blackColor];
    field.canDismiss=!layoutEditing;
    self.backgroundColor=[UIColor whiteColor];
    field=[[LTTextView alloc] init];
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
    bottom.frame=CGRectMake(0, self.frame.size.height-1.0f, self.frame.size.width, 1.0f);
}

-(void)beginEditingWithCompletion:(void (^)())completionBlock
{
    initialFrame=self.frame;
    layoutEditing=YES;
    field.canDismiss=!layoutEditing;
    self.frame=self.frame;
    [UIView animateWithDuration:.15 animations:^{
        cameraButton.alpha=0;
        field.text=commentText;
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
    field.canDismiss=YES;
    [self endEditing:YES];
    field.userInteractionEnabled=NO;
    [UIView animateWithDuration:.25 animations:^{
        self.frame=initialFrame;
    } completion:^(BOOL finished){
        layoutEditing=NO;
        self.frame=self.frame;
        commentText=field.text;
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
    UIButton *cButton=[[UIButton alloc] initWithFrame:CGRectMake(margin, margin+topHeight, height, height)];
    cButton.backgroundColor=[UIColor blackColor];
    [cButton addTarget:self action:@selector(cameraTouched:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:cButton];
    return container;
}

-(void)cameraTouched:(UIButton*)cameraButton{
    [self.home.transitionController showImagePicker];
}

-(void)sendTouchUp:(UIButton*)sendButton
{
    if(_container!=nil)
    {
        eventComment *current=self.currentComment;
        [self clearCurrent];
        if(current.text.length>0||current.image!=nil){
            [_container sendTappedWithComment:current];
        }
    }
}

-(eventComment*)currentComment{
    eventComment *comm=[[eventComment alloc] init];
    comm.poster=self.poster;
    if(field.images.count>0){
        comm.image=field.images.firstObject;
    }
    comm.postingDate=[NSDate date];
    comm.text=field.textView.text;
    return comm;
}

-(void)clearCurrent{
    while(field.images.count>0){
        [field removeImage:nil];
    }
    field.text=@"";
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
    if(field.textView.inputAccessoryView==nil)
    {
        field.textView.inputAccessoryView=[self textViewAccessoryView];
    }
    return [field.textView becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return [field.textView canBecomeFirstResponder];
}

-(BOOL)endEditing:(BOOL)force
{
    return [field.textView endEditing:force];
}

-(void)endEditing
{
    
}

-(BOOL)resignFirstResponder
{
    return [field.textView resignFirstResponder];
}

-(void)addImage:(UIImage *)image{
    [field addImage:image];
}

-(void)removeImage:(UIImage *)image{
    [field removeImage:image];
}

-(NSArray<UIImage*>*)images{
    return field.images;
}

@end
