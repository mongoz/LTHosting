//
//  eventCommentTableViewItem.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewItem.h"
#import "eventComment.h"

@interface eventCommentTableViewItem : eventPageTableViewItem

-(id)initWithComment:(eventComment*)comment;

+(eventCommentTableViewItem*)itemWithComment:(eventComment*)comment;

@property (strong, nonatomic) eventComment *comment;

@end
