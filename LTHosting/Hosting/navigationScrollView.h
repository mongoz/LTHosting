//
//  navigationScrollView.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventsNavigationController.h"

@interface navigationScrollView : UIScrollView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) eventsNavigationController *controller;

@end
