//
//  flyerTableViewCell.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageTableViewCell.h"
#import "flyerTableViewItem.h"

@interface flyerTableViewCell : eventPageTableViewCell

@property (strong, readwrite, nonatomic) flyerTableViewItem *item;

@end
