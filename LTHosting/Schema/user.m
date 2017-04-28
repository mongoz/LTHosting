//
//  user.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "user.h"

@implementation user

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    _name=[aDecoder decodeObjectForKey:@"name"];
    _profileImage=[aDecoder decodeObjectForKey:@"profile_image"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_profileImage forKey:@"profile_image"];
}

@end
