//
//  eventPageViewController.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/5/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RETableViewManager/RETableViewManager.h>
#import "event.h"
#import "commentAddView.h"

@class commentAddContainer;
@class commentsHeaderView;

@protocol transitionController<NSObject>

-(void)transitionToProfileForUser:(user*)user;

-(void)transitionToEventDetails:(event*)event;

-(void)containerDidEndEditing:(commentAddContainer*)container;

-(void)shouldBeginCommentEditingWithHeader:(commentsHeaderView*)header;

@end

@interface eventPageViewController : UIViewController<RETableViewManagerDelegate, transitionController, CLLocationManagerDelegate>

@property (strong, nonatomic) RETableViewManager *manager;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) event *event;

@end

