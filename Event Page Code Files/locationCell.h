//
//  locationCell.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
#import "locationItem.h"

@interface locationCell : RETableViewCell

@property (strong, readwrite, nonatomic) locationItem *item;

@end
