//
//  eventTableViewItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewItem.h"
#import "event.h"

@interface eventTableViewItem : eventPageTableViewItem

@property (strong, nonatomic) event *event;

@property (strong, nonatomic) CLLocationManager *locationManager;

-(id)initWithEvent:(event*)event locationManager:(CLLocationManager*)manager transitionController:(id<transitionController>)transitionController;

+(eventTableViewItem*)itemWithEvent:(event*)event locationManager:(CLLocationManager*)manager transitionController:(id<transitionController>)transitionController;

@end
