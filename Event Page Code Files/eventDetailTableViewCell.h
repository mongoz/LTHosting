//
//  eventDetailTableViewCell.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewCell.h"
#import "eventTableViewItem.h"

@interface eventDetailTableViewCell : eventPageTableViewCell

@property (strong, readwrite, nonatomic) eventTableViewItem *item;

@end
