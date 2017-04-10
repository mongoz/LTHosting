//
//  eventTableViewItem.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventTableViewItem.h"

@implementation eventTableViewItem

-(id)initWithEvent:(event *)event locationManager:(CLLocationManager *)manager transitionController:(id<transitionController>)transitionController
{
    self=[self init];
    _event=event;
    _locationManager=manager;
    self.transitionController=transitionController;
    return self;
}

+(eventTableViewItem*)itemWithEvent:(event*)event locationManager:(CLLocationManager *)manager transitionController:(id<transitionController>)transitionController
{
    return [[self alloc] initWithEvent:event locationManager:manager transitionController:transitionController];
}

-(void(^)(id))selectionHandler
{
    return ^(eventTableViewItem* item){
        [item.transitionController transitionToEventDetails:self.event];
        [item deselectRowAnimated:YES];
    };
}

@end
