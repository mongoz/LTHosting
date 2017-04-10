//
//  commentsHeaderView.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "commentsHeaderView.h"

@interface commentsHeaderView(){
    commentAddView *addView;
    user *myUser;
    UIGestureRecognizer *tap;
}

@end

@implementation commentsHeaderView

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
    myUser=nil;
    _transitionController=nil;
    addView=[[commentAddView alloc] init];
    addView.home=self;
    [self addSubview:addView];
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)tapped:(UITapGestureRecognizer*)tap
{
    if(_transitionController!=nil)
    {
        [_transitionController shouldBeginCommentEditingWithHeader:self];
    }
}

-(id)initWithUser:(user*)someUser transitionController:(id<transitionController>)controller
{
    self=[self init];
    self.currentUser=someUser;
    _transitionController=controller;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(addView!=nil)
    {
        addView.frame=self.bounds;
    }
}

-(void)setCurrentUser:(user *)currentUser
{
    myUser=currentUser;
    if(addView!=nil)
    {
        addView.poster=myUser;
    }
}

-(user*)currentUser
{
    return myUser;
}

-(void)returnCommentAddView:(commentAddView *)view
{
    if(view==nil||addView!=nil)
    {
        return;
    }
    tap.enabled=YES;
    [self addSubview:view];
    addView=view;
    addView.frame=self.bounds;
}

-(commentAddView*)retrieveCommentAddView
{
    if(addView.superview!=self)
    {
        return nil;
    }
    tap.enabled=NO;
    commentAddView *v=addView;
    [addView removeFromSuperview];
    addView=nil;
    return v;
}

@end
