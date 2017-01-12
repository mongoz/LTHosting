//
//  eventOptionTableViewCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventDetailViewController.h"

@interface eventOptionTableViewCell : UITableViewCell

@property (strong, nonatomic) eventDetailViewController *parent;

+(eventOptionTableViewCell*)cellForOption:(NSString*)option type:(NSNumber*)type table:(UITableView*)table withParent:(eventDetailViewController*)parent;

+(eventOptionTableViewCell*)cellForOption:(NSString*)option table:(UITableView*)table withParent:(eventDetailViewController*)parent;

-(void)update;

@property (strong) NSString *option;
@end
