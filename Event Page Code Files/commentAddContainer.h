//
//  commentAddContainer.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventPageViewController.h"

@interface commentAddContainer : UIView<UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

-(void)giveCommentAddView:(commentAddView*)view;

-(commentAddView*)retrieveCommentAddView;

@property (weak, nonatomic) id<transitionController> transitionController;

-(id)initWithTransitionController:(id<transitionController>)controller;

-(void)sendTapped;

@end
