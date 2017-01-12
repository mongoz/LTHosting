//
//  eventOptionsTextTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventOptionsTextTableViewCell.h"


@implementation eventOptionsTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if(![_selectionText.text isEqualToString:@"Add"])
    {
        [_selectionText setFont:[UIFont boldSystemFontOfSize:_selectionText.font.pointSize]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(eventOptionTableViewCell*)cellForOption:(NSString *)option table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    eventOptionsTextTableViewCell *new=[table dequeueReusableCellWithIdentifier:@"textOptionCell"];
    new.option=option;
    new.optionText.text=option;
    [new setSelectionStyle:UITableViewCellSelectionStyleGray];
    [new.optionText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [new.selectionText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    
    NSObject *parentOption=[parent.creation objectForOption:option];
    NSString *selectionText;
    if([option isEqualToString:@"Date"])
    {
        if([(NSDate*)parentOption isEqual:[NSDate distantPast]])
        {
            selectionText=@"Add";
        }
        else
        {
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateStyle:NSDateFormatterShortStyle];
            [format setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
            [format setDateFormat:@"h:mm a, M/d"];
            selectionText=[format stringFromDate:(NSDate*)parentOption];
        }
    }
    else
    {
        selectionText=(NSString*)parentOption;
    }
    new.selectionText.text=(NSString*)selectionText;
    if(![new.selectionText.text isEqualToString:@"Add"])
    {
        if([option isEqualToString:@"Date"])
        {
            [new.selectionText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
        }
        else
        {
            [new.selectionText setFont:[UIFont boldSystemFontOfSize:new.selectionText.font.pointSize]];
        }
    }
    return new;
}

-(void)updateSelection:(NSString *)selection
{
    BOOL isBold=NO;
    if([_selectionText.font isEqual:[UIFont boldSystemFontOfSize:_selectionText.font.pointSize]])
    {
        isBold=YES;
    }
    UIFont *selectionFont;
    if([self.option isEqualToString:@"Date"])
    {
        selectionFont=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    }
    else
    {
        selectionFont=[UIFont boldSystemFontOfSize:_selectionText.font.pointSize];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_selectionText setText:selection];
        if(!isBold)
        {
            [_selectionText setFont:selectionFont];
            [_selectionText setTextColor:[UIColor blackColor]];
        }
    }];
}

-(void)update
{
    [self.parent updateOption:self.option withSelection:_selectionText.text];
}

@end
