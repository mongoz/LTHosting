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
#import "eventPageFooterView.h"
#import "LTImagePickerController.h"

@class eventPageHeaderView;
@class commentAddContainer;
@class commentsHeaderView;

@protocol transitionController<NSObject>

-(void)transitionToProfileForUser:(user*)user;

-(void)transitionToEventDetails:(event*)event;

-(void)containerDidEndEditing:(commentAddContainer*)container;

-(void)shouldBeginCommentEditingWithHeader:(commentsHeaderView*)header;

-(void)showImagePicker;

-(void)postComment:(eventComment*)comment;

@end

@interface eventPageViewController : UIViewController<RETableViewManagerDelegate, transitionController, CLLocationManagerDelegate, eventPageFooterViewDelegate, LTImagePickerControllerDelegate>

@property (strong, nonatomic) RETableViewManager *manager;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) event *event;

@property (strong, nonatomic) IBOutlet eventPageHeaderView *header;

@end

