//
//  commentAddContainer.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "commentAddContainer.h"

@interface commentAddContainer(){
    CGRect initialFrame;
    commentAddView *addView;
    UIDynamicAnimator *animator;
    BOOL animatingDown;
    BOOL animatingUp;
    CGFloat gravityMagnitude;
    CGRect keyboardRect;
}

@end;

@implementation commentAddContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(commentAddView*)addView{
    return addView;
}

-(id)init
{
    self=[super init];
    gravityMagnitude=3.0f;
    animatingDown=NO;
    animatingUp=NO;
    keyboardRect=CGRectZero;
    _transitionController=nil;
    initialFrame=CGRectZero;
    addView=nil;
    animator=[[UIDynamicAnimator alloc] initWithReferenceView:self];
    animator.delegate=self;
    return self;
}

-(void)registerForKeyBoardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

void (^keyboardWillShowCompletionBlock)(CGRect)=nil;

-(BOOL)makeView:(UIView*)view firstResponderWithCompletion:(void(^)(CGRect keyboardFrame))completionBlock
{
    if(!view.canBecomeFirstResponder)
    {
        if(completionBlock!=nil)
        {
            completionBlock(CGRectNull);
        }
        return NO;
    }
    [view becomeFirstResponder];
    keyboardWillShowCompletionBlock=completionBlock;
    return YES;
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info=[notification userInfo];
    NSValue *val=[info valueForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardRect=[val CGRectValue];
    addView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-keyboardRect.size.height);
    if(keyboardWillShowCompletionBlock!=nil)
    {
        keyboardWillShowCompletionBlock([val CGRectValue]);
        keyboardWillShowCompletionBlock=nil;
    }
}

-(void)tapped:(UITapGestureRecognizer*)tap
{
    [addView endEditingWithCompletion:^{
        if(initialFrame.origin.y>0){
            [self dropToInitialFrameWithCompletion:^{
                if(self.transitionController!=nil)
                {
                    [_transitionController containerDidEndEditing:self];
                }
            }];
        }
        else{
            addView.frame=initialFrame;
            if(self.transitionController!=nil){
                [_transitionController containerDidEndEditing:self];
            }
        }
    }];
}

-(void)sendTappedWithComment:(eventComment *)comment
{
    [self tapped:nil];
    if(comment!=nil){
        [self.transitionController postComment:comment];
    }
}

-(id)initWithTransitionController:(id<transitionController>)controller
{
    self=[self init];
    _transitionController=controller;
    return self;
}

-(void)giveCommentAddView:(commentAddView *)view
{
    if(addView!=nil)
    {
        return;
    }
    [self registerForKeyBoardNotifications];
    addView=view;
    addView.container=self;
    [self addSubview:view];
    initialFrame=view.frame;
    if(initialFrame.origin.y>0)
    {
        [self dropToTopWithCompletion:^{
            NSLog(@"completed");
            [addView beginEditingWithCompletion:^{
                
            }];
        }];
    }
    else{
        view.frame=CGRectMake(view.frame.origin.x,0,view.frame.size.width, view.frame.size.height);
        [addView beginEditingWithCompletion:^{
            
        }];
    }
}

-(commentAddView*)retrieveCommentAddView
{
    if(addView==nil)
    {
        return nil;
    }
    [self unregisterForKeyboardNotifications];
    commentAddView *myView=addView;
    [addView removeFromSuperview];
    addView.container=nil;
    addView=nil;
    [self unregisterForKeyboardNotifications];
    return myView;
}

void (^dropCompletionBlock)()=nil;

-(void)dropToTopWithCompletion:(void(^)())completionBlock;
{
    animatingUp=YES;
    UIGravityBehavior *grav=[[UIGravityBehavior alloc] initWithItems:@[addView]];
    [grav setGravityDirection:CGVectorMake(0, -gravityMagnitude)];
    UICollisionBehavior *collide=[[UICollisionBehavior alloc] initWithItems:@[addView]];
    collide.translatesReferenceBoundsIntoBoundary=NO;
    [collide addBoundaryWithIdentifier:@"top" fromPoint:CGPointZero toPoint:CGPointMake(self.frame.size.width, 0)];
    collide.collisionDelegate=self;
    UIAttachmentBehavior *attach=[UIAttachmentBehavior slidingAttachmentWithItem:addView attachmentAnchor:addView.center axisOfTranslation:CGVectorMake(0, 1)];
    [animator addBehavior:grav];
    [animator addBehavior:collide];
    [animator addBehavior:attach];
    dropCompletionBlock=completionBlock;
    
}

-(void)dropToInitialFrameWithCompletion:(void(^)())completionBlock
{
    animatingDown=YES;
    UIGravityBehavior *grav=[[UIGravityBehavior alloc] initWithItems:@[addView]];
    [grav setGravityDirection:CGVectorMake(0, gravityMagnitude)];
    UICollisionBehavior *collide=[[UICollisionBehavior alloc] initWithItems:@[addView]];
    collide.translatesReferenceBoundsIntoBoundary=NO;
    [collide addBoundaryWithIdentifier:@"top" fromPoint:CGPointMake(0, initialFrame.origin.y+initialFrame.size.height) toPoint:CGPointMake(self.frame.size.width, initialFrame.origin.y+initialFrame.size.height)];
    collide.collisionDelegate=self;
    UIAttachmentBehavior *attach=[UIAttachmentBehavior slidingAttachmentWithItem:addView attachmentAnchor:addView.center axisOfTranslation:CGVectorMake(0, 1)];
    [animator addBehavior:grav];
    [animator addBehavior:collide];
    [animator addBehavior:attach];
    dropCompletionBlock=completionBlock;
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    [animator removeAllBehaviors];
    if(animatingUp)
    {
        addView.frame=CGRectMake(0, 0, addView.frame.size.width, addView.frame.size.height);
        animatingUp=NO;
    }
    else if(animatingDown)
    {
        addView.frame=initialFrame;
        animatingDown=NO;
    }
    if(dropCompletionBlock!=nil)
    {
        dropCompletionBlock();
        dropCompletionBlock=nil;
    }
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}

@end
