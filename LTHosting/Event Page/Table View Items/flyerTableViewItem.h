//
//  flyerTableViewitem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewItem.h"

@interface flyerTableViewItem : eventPageTableViewItem

@property (strong, nonatomic) UIImage *flyer;

-(id)initWithFlyer:(UIImage*)flyer transitionController:(id<transitionController>)transitionController;

+(flyerTableViewItem*)itemWithFlyer:(UIImage*)flyer transitionController:(id<transitionController>)transitionController;

@end
