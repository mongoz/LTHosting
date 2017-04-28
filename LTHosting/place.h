//
//  place.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/26/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

@import GooglePlaces;

@interface place : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *placeID;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) NSString *formattedAddress;

@property (nonatomic) float rating;

@property (nonatomic) float priceLevel;

@property (strong, nonatomic) NSURL *website;

@property (strong, nonatomic) NSAttributedString *attributions;

+(instancetype)placeWithPlace:(GMSPlace*)oldPlace;

-(id)initWithPlace:(GMSPlace*)oldPlace;

@end
