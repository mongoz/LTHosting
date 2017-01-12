//
//  eventOptionsSwitchTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventOptionsSwitchTableViewCell.h"

@interface eventOptionsSwitchTableViewCell() {
    NSString *selected;
}
@end

@implementation eventOptionsSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if([_optionSwitch isOn])
    {
        selected=_rightText.text;
    }
    else
    {
        selected=_leftText.text;
    }
}

- (void)setSelected:(BOOL)select animated:(BOOL)animated {
    [super setSelected:select animated:animated];

    // Configure the view for the selected state
}

+(eventOptionTableViewCell*)cellForOption:(NSString*)option table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    eventOptionsSwitchTableViewCell *new=[table dequeueReusableCellWithIdentifier:@"switchOptionCell"];
    new.option=option;
    if([option isEqualToString:@"Private"])
    {
        new.leftText.text=@"Private";
        new.rightText.text=@"Public";
    }
    else if([option isEqualToString:@"Free"])
    {
        new.leftText.text=@"Free";
        new.rightText.text=@"Paid";
    }
    [new setSelectionStyle:UITableViewCellSelectionStyleNone];
    [new.leftText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [new.rightText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    new.option=option;
    return new;
}

- (IBAction)changeOption:(id)sender {
    NSString *selection;
    if([_optionSwitch isOn])
    {
        selection=_rightText.text;
    }
    else
    {
        selection=_leftText.text;
    }
    [self.parent updateOption:self.option withSelection:selection];
    selected=selection;
}

-(void)toggleSwitch
{
    [_optionSwitch setOn:![_optionSwitch isOn] animated:YES];
}

-(void)update
{
    [self.parent updateOption:self.option withSelection:selected];
}

@end
