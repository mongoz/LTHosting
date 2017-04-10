//
//  profileButton.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventPageViewController.h"

@interface profileButton : UIButton

-(id)initWithUser:(user*)user;

-(id)initWithFrame:(CGRect)frame user:(user*)user;

@property (strong, nonatomic) user *user;

@property (weak, nonatomic) id<transitionController> transitionController;

@property (nonatomic) NSTimeInterval animationDuration;

@property (nonatomic) CGFloat touchScale;

@property (nonatomic) BOOL resizesOnTouch;

@end
