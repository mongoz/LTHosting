//
//  hostingHubViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"

@class hostingHubPageController;

@protocol hubVC <NSObject>

@property (strong, nonatomic, readonly) UIButton *leftButton;

@property (strong, nonatomic, readonly) UIButton *rightButton;

@property (weak, nonatomic) hostingHubPageController *pageViewController;

@end

@interface hostingHubPageController : UIPageViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) event *event;

@property (nonatomic) NSInteger page;

-(void)setPage:(NSInteger)page animated:(BOOL)animated completion:(void(^)())completionBlock;

-(void)setPage:(NSInteger)page animated:(BOOL)animated;

@end
