//
//  hubRequestsViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RETableViewManager/RETableViewManager.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "hostingHubPageController.h"

@interface hubRequestsViewController : UIViewController<DZNEmptyDataSetSource, hubVC, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) hostingHubPageController *pageViewController;

@end
