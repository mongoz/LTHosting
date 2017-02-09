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


-(NSAttributedString*)flyerBodyForCurrentState
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"h:mm a, M/d/YYYY"];
    NSString *dateString=[formatter stringFromDate:self.date];
    NSMutableAttributedString *full=[[NSMutableAttributedString alloc] init];
    NSMutableArray<NSAttributedString*>* lines=[[NSMutableArray alloc] init];
    [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Start: %@",dateString]]];
    [lines addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"About: %@",_about]]];
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
        [lastLine appendString:@"Paid"];
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
