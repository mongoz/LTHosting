//
//  eventCommentTableViewItem.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventCommentTableViewItem.h"

@implementation eventCommentTableViewItem

-(id)init{
    self=[super init];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}

-(id)initWithComment:(eventComment *)comment{
    self=[self init];
    _comment=comment;
    return self;
}

+(eventCommentTableViewItem*)itemWithComment:(eventComment *)comment{
    return [[self alloc] initWithComment:comment];
}

@end
