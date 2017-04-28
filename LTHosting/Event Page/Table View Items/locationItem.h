//
//  locationItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
#import "place.h"

@interface locationItem : RETableViewItem

@property (strong, nonatomic) place *place;

@property (strong, nonatomic) NSString *addressString;

-(id)initWithPlace:(place*)somePlace addressString:(NSString*)string;

-(id)initWithPlace:(place*)somePlace;

-(id)initWithAddressString:(NSString*)string;

+(locationItem*)itemWithPlace:(place*)somePlace addressString:(NSString*)string;

+(locationItem*)itemWithPlace:(place*)somePlace;

+(locationItem*)itemWithAddressString:(NSString*)addressString;

@end
