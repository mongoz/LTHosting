//
//  locationItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
@import GooglePlaces;

@interface locationItem : RETableViewItem

@property (strong, nonatomic) GMSPlace *place;

@property (strong, nonatomic) NSString *addressString;

-(id)initWithPlace:(GMSPlace*)somePlace addressString:(NSString*)string;

-(id)initWithPlace:(GMSPlace*)somePlace;

-(id)initWithAddressString:(NSString*)string;

+(locationItem*)itemWithPlace:(GMSPlace*)somePlace addressString:(NSString*)string;

+(locationItem*)itemWithPlace:(GMSPlace*)somePlace;

+(locationItem*)itemWithAddressString:(NSString*)addressString;

@end
