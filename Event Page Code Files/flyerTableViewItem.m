//
//  flyerTableViewitem.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerTableViewItem.h"

@implementation flyerTableViewItem

-(id)initWithFlyer:(UIImage *)flyer transitionController:(id<transitionController>)transitionController
{
    self=[self init];
    _flyer=flyer;
    self.transitionController=transitionController;
    return self;
}

+(flyerTableViewItem*)itemWithFlyer:(UIImage *)flyer transitionController:(id<transitionController>)transitionController
{
    flyerTableViewItem *new=[[self alloc] initWithFlyer:flyer transitionController:transitionController];
    return new;
}

@end
