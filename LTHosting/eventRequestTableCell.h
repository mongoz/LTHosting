//
//  eventRequestTableCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface eventRequestTableCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
