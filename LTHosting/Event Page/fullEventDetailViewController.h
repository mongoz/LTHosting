//
//  fullEventDetailViewController.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"
#import <RETableViewManager/RETableViewManager.h>

@interface fullEventDetailViewController : UIViewController<RETableViewManagerDelegate>

@property (strong, nonatomic) event *event;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) RETableViewManager *manager;

@end
