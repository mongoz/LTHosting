//
//  event.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "event.h"

@interface event() {
    NSDictionary<NSString*,id> *optionDictionary;
}
@end

@implementation event

-(id)init
{
    if(self=[super init])
    {
        self=[super init];
        NSString *string=@"Add";
        _date=[NSDate distantPast];
        _music=[string copy];
        _venue=[string copy];
        _isPrivate=YES;
        _isFree=YES;
        _name=[string copy];
        _address=[string copy];
        _about=[string copy];
        _image=[[UIImage alloc] init];
        _flyer=[[UIImage alloc] init];
        [self generateOptionDictionary];
    }
    return self;
}

+(event*)sharedInstance
{
    static event *sharedEvent=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvent=[[self alloc] init];
    });
    return sharedEvent;
}

-(void)generateOptionDictionary
{
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    [temp setObject:_name forKey:@"Name"];
    [temp setObject:_address forKey:@"Address"];
    [temp setObject:_about forKey:@"About"];
    [temp setObject:_date forKey:@"Date"];
    [temp setObject:[NSNumber numberWithBool:_isPrivate] forKey:@"Private"];
    [temp setObject:[NSNumber numberWithBool:_isFree] forKey:@"Free"];
    [temp setObject:_music forKey:@"Music"];
    [temp setObject:_venue forKey:@"Venue"];
    [temp setObject:_image forKey:@"Image"];
    [temp setObject:_flyer forKey:@"Flyer"];
    optionDictionary=temp;
}

-(void)print
{
    NSLog(@"%@, %@, %@, %@, %ld, %ld, %@, %@",_name,_address,_about,_date,(long)_isPrivate,(long)_isFree,_music,_venue);
}

-(id)objectForOption:(NSString *)option
{
    if([option isEqualToString:@"Name"])
    {
        return _name;
    }
    if([option isEqualToString:@"Address"])
    {
        return _address;
    }
    if([option isEqualToString:@"About"])
    {
        return _about;
    }
    if([option isEqualToString:@"Date"])
    {
        return _date;
    }
    if([option isEqualToString:@"Private"])
    {
        return [NSNumber numberWithBool:_isPrivate];
    }
    if([option isEqualToString:@"Free"])
    {
        return [NSNumber numberWithBool:_isFree];
    }
    if([option isEqualToString:@"Music"])
    {
        return _music;
    }
    if([option isEqualToString:@"Venue"])
    {
        return _venue;
    }
    if([option isEqualToString:@"Image"])
    {
        return _image;
    }
    if([option isEqualToString:@"Flyer"])
    {
        return _flyer;
    }
    return [NSNumber numberWithInt:-1];
}

@end
