//
//  locationItem.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "locationItem.h"

@interface locationItem(){
}

@end

@implementation locationItem

-(id)init
{
    self=[super init];
    _place=nil;
    _addressString=nil;
    return self;
}

-(id)initWithPlace:(place *)somePlace addressString:(NSString *)string
{
    self=[self init];
    _place=somePlace;
    _addressString=string;
    return self;
}

-(id)initWithPlace:(place *)somePlace
{
    return [self initWithPlace:somePlace addressString:somePlace.name];
}

-(id)initWithAddressString:(NSString *)string
{
    return [self initWithPlace:nil addressString:string];
}

+(locationItem*)itemWithPlace:(place *)somePlace addressString:(NSString *)string
{
    return [[self alloc] initWithPlace:somePlace addressString:string];
}

+(locationItem*)itemWithPlace:(place *)somePlace
{
    return [[self alloc] initWithPlace:somePlace];
}

+(locationItem*)itemWithAddressString:(NSString *)addressString
{
    return [[self alloc] initWithAddressString:addressString];
}

-(void(^)(id))selectionHandler
{
    return ^(locationItem* item){
        if(item.place!=nil)
        {
            [self openPlaceInGoogleMaps:item.place completion:^(BOOL success){}];
        }
        [item deselectRowAnimated:YES];
    };
}

-(void)openPlaceInGoogleMaps:(place*)place completion:(void(^)(BOOL))completionBlock
{
    NSMutableString *myString=[[NSMutableString alloc] init];
    [myString appendString:@"comgooglemaps-x-callback://?"];
    [myString appendString:@"q="];
    [myString appendString:[place.formattedAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    [myString appendString:@"&"];
    CLLocationCoordinate2D coor=place.coordinate;
    [myString appendString:[NSString stringWithFormat:@"center=%f,%f",coor.latitude,coor.longitude]];
    [self openURLWithString:myString withCompletionBlock:^(BOOL success){
        if(!success)
        {
            [self openPlaceInAppleMaps:place completion:completionBlock];
        }
        if(completionBlock!=nil)
        {
            completionBlock(success);
        }
    }];
}

-(void)openPlaceInAppleMaps:(place*)place completion:(void(^)(BOOL))completionBlock
{
    NSMutableString *myString=[[NSMutableString alloc] init];
    [myString appendString:@"http://maps.apple.com/?"];
    [myString appendString:@"q="];
    [myString appendString:[place.formattedAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    [myString appendString:@"&"];
    CLLocationCoordinate2D coor=place.coordinate;
    [myString appendString:[NSString stringWithFormat:@"ll=%f,%f",coor.latitude,coor.longitude]];
    [self openURLWithString:myString withCompletionBlock:completionBlock];
}

-(void)openURLWithString:(NSString*)string withCompletionBlock:(void(^)(BOOL))completionBlock{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:[NSNumber numberWithBool:NO]} completionHandler:^(BOOL success){
        if(completionBlock!=nil)
        {
            completionBlock(success);
        }
    }];
}


@end
