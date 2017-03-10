//
//  eventPageTableViewItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
#import "eventPageViewController.h"

@interface eventPageTableViewItem : RETableViewItem

@property (weak, nonatomic) id<transitionController> transitionController;

@end
