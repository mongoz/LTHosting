//
//  place.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/26/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "place.h"

@implementation place

-(id)initWithPlace:(GMSPlace *)oldPlace{
    self=[self init];
    _name=oldPlace.name;
    _placeID=oldPlace.placeID;
    _coordinate=oldPlace.coordinate;
    _phoneNumber=oldPlace.phoneNumber;
    _formattedAddress=oldPlace.formattedAddress;
    _rating=oldPlace.rating;
    _priceLevel=oldPlace.priceLevel;
    _website=oldPlace.website;
    _attributions=oldPlace.attributions;
    return self;
}

+(instancetype)placeWithPlace:(GMSPlace *)oldPlace{
    return [[self alloc] initWithPlace:oldPlace];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    id (^decode)(NSString*)=^id(NSString *key){
        return [aDecoder decodeObjectForKey:key];
    };
    _name=decode(@"name");
    _placeID=decode(@"placeID");
    CGPoint coor=[aDecoder decodeCGPointForKey:@"coordinate"];
    _coordinate=CLLocationCoordinate2DMake(coor.x, coor.y);
    _phoneNumber=decode(@"phoneNumber");
    _formattedAddress=decode(@"formattedAddress");
    _rating=[aDecoder decodeFloatForKey:@"rating"];
    _priceLevel=[aDecoder decodeFloatForKey:@"priceLevel"];
    _website=decode(@"website");
    _attributions=decode(@"attributions");
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    void (^encode)(NSString*, id)=^(NSString *propName, id ob){
        [aCoder encodeObject:ob forKey:propName];
    };
    encode(@"name",_name);
    encode(@"placeID",_placeID);
    [aCoder encodeCGPoint:CGPointMake(_coordinate.latitude, _coordinate.longitude) forKey:@"coordinate"];
    encode(@"phoneNumber",_phoneNumber);
    encode(@"formattedAddress",_formattedAddress);
    [aCoder encodeFloat:_rating forKey:@"rating"];
    [aCoder encodeFloat:_priceLevel forKey:@"priceLevel"];
    encode(@"website",_website);
    encode(@"attributions",_attributions);
}

@end
