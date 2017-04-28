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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    _date=[aDecoder decodeObjectForKey:@"Date"];
    _music=[aDecoder decodeObjectForKey:@"Music"];
    _isPrivate=[aDecoder decodeBoolForKey:@"isPrivate"];
    _isFree=[aDecoder decodeBoolForKey:@"isFree"];
    _name=[aDecoder decodeObjectForKey:@"Name"];
    _address=[aDecoder decodeObjectForKey:@"Address"];
    _fullAddressInfo=[aDecoder decodeObjectForKey:@"FullAddressInfo"];
    _about=[aDecoder decodeObjectForKey:@"About"];
    _venue=[aDecoder decodeObjectForKey:@"Venue"];
    _image=[aDecoder decodeObjectForKey:@"Image"];
    _flyer=[aDecoder decodeObjectForKey:@"Flyer"];
    _poster=[aDecoder decodeObjectForKey:@"Poster"];
    _comments=[aDecoder decodeObjectForKey:@"Comments"];
    _flyerObject=[aDecoder decodeObjectForKey:@"FlyerObject"];
    _requesting=[aDecoder decodeObjectForKey:@"requesting"];
    _attending=[aDecoder decodeObjectForKey:@"attending"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_date forKey:@"Date"];
    [aCoder encodeObject:_music forKey:@"Music"];
    [aCoder encodeBool:_isPrivate forKey:@"isPrivate"];
    [aCoder encodeBool:_isFree forKey:@"isFree"];
    [aCoder encodeObject:_name forKey:@"Name"];
    [aCoder encodeObject:_address forKey:@"Address"];
    [aCoder encodeObject:_fullAddressInfo forKey:@"FullAddressInfo"];
    [aCoder encodeObject:_about forKey:@"About"];
    [aCoder encodeObject:_venue forKey:@"Venue"];
    [aCoder encodeObject:_image forKey:@"Image"];
    [aCoder encodeObject:_flyer forKey:@"Flyer"];
    [aCoder encodeObject:_poster forKey:@"Poster"];
    [aCoder encodeObject:_comments forKey:@"Comments"];
    [aCoder encodeObject:_flyerObject forKey:@"FlyerObject"];
    [aCoder encodeObject:_requesting forKey:@"requesting"];
    [aCoder encodeObject:_attending forKey:@"attending"];
}

-(id)init
{
    if(self=[super init])
    {
        self=[super init];
        NSString *string=@"";
        _date=[NSDate date];
        _music=[string copy];
        _venue=[string copy];
        _isPrivate=YES;
        _isFree=YES;
        _name=[string copy];
        _address=[string copy];
        _about=[string copy];
        _image=[[UIImage alloc] init];
        _flyer=[[UIImage alloc] init];
        _requesting=[[NSMutableArray alloc] init];
        _attending=[[NSMutableArray alloc] init];
        [self generateOptionDictionary];
    }
    return self;
}

static event *SHARED_EVENT=nil;

+(event*)sharedInstance
{
    if(SHARED_EVENT==nil){
        SHARED_EVENT=[[self alloc] init];
    }
    return SHARED_EVENT;
}

+(void)resetSharedInstance{
    SHARED_EVENT=nil;
}

+(void)setSharedInstance:(event *)existing{
    SHARED_EVENT=existing;
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


-(NSAttributedString*)flyerBodyForCurrentState
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"h:mm a, M/d/YYYY"];
    NSString *dateString=[formatter stringFromDate:self.date];
    NSMutableAttributedString *full=[[NSMutableAttributedString alloc] init];
    NSMutableArray<NSAttributedString*>* lines=[[NSMutableArray alloc] init];
    [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dateString]]];
    if(!_isPrivate){
        [lines addObject:[[NSAttributedString alloc] initWithString:_address]];
    }
    if(![_about isEqualToString:@""])
    {
        while([[_about substringFromIndex:_about.length-1] isEqualToString:@"\n"])
        {
            _about=[_about substringToIndex:_about.length-1];
        }
        [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_about]]];
    }
    if(![_music isEqualToString:@"Music"])
    {
        [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Music: %@",_music]]];
    }
    if(![_venue isEqualToString:@"Venue"])
    {
        [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Venue: %@",_venue]]];
    }
    NSMutableString *lastLine=[[NSMutableString alloc] init];
    BOOL both=NO;
    if(_isPrivate)
    {
        [lastLine appendString:@"Private"];
        both=YES;
    }
    if(!_isFree)
    {
        if(both)
        {
            [lastLine appendString:@", "];
        }
        [lastLine appendString:@"Entry Fee"];
        both=YES;
    }
    NSAttributedString  *final=[[NSAttributedString alloc] initWithString:lastLine attributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]] forKey:NSFontAttributeName]];
    if(both)
    {
        [lines addObject:final];
    }
    for(NSInteger i=0; i<lines.count; i++)
    {
        [full appendAttributedString:lines[i]];
        if(i<lines.count-1)
        {
            [full appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    NSLog(@"%@",full);
    return full;
}

-(NSString*)dateString
{
    return [self stringForDate:self.date];
}

-(NSString*)stringForDate:(NSDate*)date
{
    NSDateComponents *comp=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitSecond) fromDate:date];
    NSDateComponents *now=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    NSTimeInterval interval=[date timeIntervalSinceNow];
    
    NSTimeInterval effectiveTime=ceil(interval-(comp.hour*60*60)-comp.minute*60-comp.second+(now.hour*60*60)+now.minute*60+now.second);
    effectiveTime=effectiveTime/(24*60*60);
    if(effectiveTime<1)
    {
        CGFloat hours=interval/(60*60);
        CGFloat extra=0;
        if(hours-floor(hours)<=.25)
        {
            extra=0;
        }
        else if(hours-floor(hours)>.25&&hours-floor(hours)<.75)
        {
            extra=.5;
        }
        else if(hours-floor(hours)>=.75)
        {
            extra=1;
        }
        hours=floor(hours)+extra;
        NSString *hourText;
        if(hours==0)
        {
            return @"Now";
        }
        if(hours==1)
        {
            hourText=@"1 Hour";
        }
        else
        {
            if(hours!=floor(hours))
            {
                hourText=[NSString stringWithFormat:@"%.01f Hours",(double)hours];
            }
            else
            {
                hourText=[NSString stringWithFormat:@"%.f Hours",(double)hours];
            }
        }
        return [NSString stringWithFormat:@"In %@",hourText];
    }
    else if(effectiveTime>=1&&effectiveTime<2)
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm a"];
        return [NSString stringWithFormat:@"Tomorrow, %@",[formatter stringFromDate:date]];
    }
    else if(effectiveTime>=2&&effectiveTime<7)
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setDateFormat:@"EEEE, h:mm a"];
        return [formatter stringFromDate:date];
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setDateFormat:@"M/dd, h:mm a"];
        return [formatter stringFromDate:date];
    }
}


@end
