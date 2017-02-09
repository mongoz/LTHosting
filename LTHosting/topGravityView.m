//
//  topGravityView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "topGravityView.h"

@interface topGravityView(){
    UIScrollView *scrollView;
    UIDynamicAnimator *animator;
    NSMutableArray<UIView*>* viewStack;
    
    UIView *topView;
}
@end

@implementation topGravityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self configureView];
    return self;
}

-(void)configureView
{
    viewStack=[[NSMutableArray alloc] init];
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView addSubview:topView];
    animator=[[UIDynamicAnimator alloc] initWithReferenceView:scrollView];
    animator.delegate=self;
    [self addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    CGPoint lastOrigin=CGPointMake(0, 0);
    for(NSInteger i=0; i<10; i++){
    
    }
    [animator addBehavior:[self behavior]];
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animato
{
    NSLog(@"paused");
    [animato removeAllBehaviors];
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    NSLog(@"will resume");
}

-(IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    for(NSInteger i=0; i<viewStack.count; i++)
    {
        if(viewStack[i]==tap.view)
        {
            [self increaseFrameAtIndex:i];
            return;
        }
    }
    [animator removeAllBehaviors];
    [UIView animateWithDuration:.25 animations:^{
        [tap.view setFrame:CGRectMake(tap.view.frame.origin.x, tap.view.frame.origin.y, tap.view.frame.size.width, tap.view.frame.size.height*1.5)];
    } completion:^(BOOL finished){
        [self layoutIfNeeded];
        [animator addBehavior:[self behavior]];
    }];
}

-(UIDynamicBehavior*)behavior
{
    UIDynamicBehavior *behavior=[[UIDynamicBehavior alloc] init];
    
    for(UIView *v in viewStack)
    {
        UIAttachmentBehavior *attach=[UIAttachmentBehavior slidingAttachmentWithItem:v attachmentAnchor:v.frame.origin axisOfTranslation:CGVectorMake(0.0f, 1.0f)];
        UIAttachmentBehavior *attachagain=[UIAttachmentBehavior slidingAttachmentWithItem:v attachmentAnchor:CGPointMake(v.frame.origin.x+v.frame.size.width, v.frame.origin.y) axisOfTranslation:CGVectorMake(0.0f, 1.0f)];
        [behavior addChildBehavior:attach];
        [behavior addChildBehavior:attachagain];
    }
    
    UICollisionBehavior *collide=[[UICollisionBehavior alloc] initWithItems:viewStack];
    collide.collisionDelegate=self;
    [collide addBoundaryWithIdentifier:@"top" fromPoint:topView.frame.origin toPoint:CGPointMake(topView.frame.origin.x+topView.frame.size.width, topView.frame.origin.y)];
    [collide setCollisionMode:UICollisionBehaviorModeEverything];
    
    
    UIPushBehavior *push=[[UIPushBehavior alloc] initWithItems:viewStack mode:UIPushBehaviorModeContinuous];
    [push setPushDirection:CGVectorMake(0.0f, -1.0f)];
    [push setMagnitude:5.0f];
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc] initWithItems:viewStack];
    [gravity setGravityDirection:CGVectorMake(0, -1.0f)];
    
    [behavior addChildBehavior:collide];
    [behavior addChildBehavior:gravity];
    
    [topView setFrame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height)];
    UIAttachmentBehavior *attachTop=[[UIAttachmentBehavior alloc] initWithItem:topView attachedToAnchor:topView.center];
    UISnapBehavior *snapTop=[[UISnapBehavior alloc] initWithItem:topView snapToPoint:topView.center];
    
    UIAttachmentBehavior *attachToTop=[[UIAttachmentBehavior alloc] initWithItem:viewStack.firstObject attachedToItem:topView];
    [behavior addChildBehavior:attachToTop];
    [behavior addChildBehavior:snapTop];
    return behavior;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    void (^attach)(id<UIDynamicItem>,id<UIDynamicItem>)=^(id<UIDynamicItem> item1,id<UIDynamicItem>item2){
        UIAttachmentBehavior *attach=[[UIAttachmentBehavior alloc] initWithItem:item1 attachedToItem:item2];
        [animator addBehavior:attach];
    };
    attach(item1,item2);
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    
}

-(void)increaseFrameAtIndex:(NSInteger)index
{
    [animator removeAllBehaviors];
    NSMutableArray<UIView*>* before=[[NSMutableArray alloc] init];
    for(NSInteger i=index+1; i<viewStack.count; i++)
    {
        [before addObject:viewStack[i]];
    }
    UIGravityBehavior *grav=[[UIGravityBehavior alloc] initWithItems:before];
    [grav setMagnitude:100.0f];
    UIPushBehavior *push=[[UIPushBehavior alloc] initWithItems:before mode:UIPushBehaviorModeContinuous];
    [push setMagnitude:200.0f];
    [push setAngle:M_PI_2];
    [animator addBehavior:grav];
    [UIView transitionWithView:viewStack[index] duration:.4 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        UIView *v=viewStack[index];
        [v setFrame:CGRectMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height*1.5)];
        
    }completion:^(BOOL finished){
        [animator removeAllBehaviors];
        [animator addBehavior:[self behavior]];
    }];
}



@end
