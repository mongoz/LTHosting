//
//  eventOptionsSwitchTableViewCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventOptionTableViewCell.h"

@interface eventOptionsSwitchTableViewCell : eventOptionTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *leftText;

@property (strong, nonatomic) IBOutlet UILabel *rightText;

@property (strong, nonatomic) IBOutlet UISwitch *optionSwitch;

- (IBAction)changeOption:(id)sender;

-(void)toggleSwitch;
@end
