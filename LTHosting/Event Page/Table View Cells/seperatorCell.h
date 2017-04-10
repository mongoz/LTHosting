//
//  seperatorCell.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>
#import "seperatorTableViewItem.h"

@interface seperatorCell : RETableViewCell

@property (strong, readwrite, nonatomic) seperatorTableViewItem *item;

@end
