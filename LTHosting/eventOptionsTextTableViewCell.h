//
//  eventOptionsTextTableViewCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventDetailViewController.h"
#import "eventOptionTableViewCell.h"

@interface eventOptionsTextTableViewCell : eventOptionTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *optionText;

@property (strong, nonatomic) IBOutlet UILabel *selectionText;

-(void)updateSelection:(NSString*)selection;


@end
