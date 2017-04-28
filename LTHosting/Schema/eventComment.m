//
//  eventComment.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventComment.h"

@implementation eventComment

-(id)init
{
    self=[super init];
    _text=nil;
    _image=nil;
    _poster=nil;
    _postingDate=nil;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    _text=[aDecoder decodeObjectForKey:@"text"];
    _image=[aDecoder decodeObjectForKey:@"image"];
    _image=[aDecoder decodeObjectForKey:@"poster"];
    _postingDate=[aDecoder decodeObjectForKey:@"posting_date"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_text forKey:@"text"];
    [aCoder encodeObject:_image forKey:@"image"];
    [aCoder encodeObject:_poster forKey:@"poster"];
    [aCoder encodeObject:_postingDate forKey:@"posting_date"];
}

@end
