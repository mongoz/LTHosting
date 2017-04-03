//
//  eventCommentTableViewCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewCell.h"
#import "eventCommentTableViewItem.h"


@interface eventCommentTableViewCell : eventPageTableViewCell

@property (strong, nonatomic) eventCommentTableViewItem *item;

@end
