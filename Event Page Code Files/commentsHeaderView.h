//
//  commentsHeaderView.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventPageViewController.h"

@interface commentsHeaderView : UIView

@property (weak, nonatomic) id<transitionController> transitionController;

-(id)initWithUser:(user*)someUser transitionController:(id<transitionController>)controller;

-(commentAddView*)retrieveCommentAddView;

-(void)returnCommentAddView:(commentAddView*)view;

@property (strong, nonatomic) user *currentUser;

@end
