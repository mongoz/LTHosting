//
//  eventOptionTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionTableViewCell.h"
#import "eventOptionsTextTableViewCell.h"
#import "eventOptionsFieldTableViewCell.h"
#import "eventOptionsSwitchTableViewCell.h"
#import "eventOptionsGoTableViewCell.h"
#import "eventOptionsImageTableViewCell.h"

@implementation eventOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(eventOptionTableViewCell*)cellForOption:(NSString *)option type:(NSNumber*)type table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    switch([type intValue])
    {
        case 0:
        case 1:
            return [eventOptionsFieldTableViewCell cellForOption:option table:table withParent:parent];
            break;
        case 2:
            return [eventOptionsTextTableViewCell cellForOption:option table:table withParent:parent];
            break;
        case 3:
            return [eventOptionsSwitchTableViewCell cellForOption:option table:table withParent:parent];
            break;
        case 5:
            return [eventOptionsImageTableViewCell cellForOption:option table:table withParent:parent];
            break;
        default:
            return [eventOptionsGoTableViewCell cellForOption:option table:table withParent:parent];
            break;
            
    }
}

@end
