//
//  eventPageHeaderView.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventPageViewController.h"

@interface eventPageHeaderView : UIButton

+(eventPageHeaderView*)headerViewForUser:(user*)user withWidth:(CGFloat)width;

-(id)initWithUser:(user*)user width:(CGFloat)width;

@property (strong, nonatomic) user *poster;

@property (weak, nonatomic) id<transitionController> profileTransitionController;

@end
