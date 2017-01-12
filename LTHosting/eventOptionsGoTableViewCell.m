//
//  eventOptionsGoTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/4/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionsGoTableViewCell.h"

@implementation eventOptionsGoTableViewCell

+(eventOptionsGoTableViewCell*)cellForOption:(NSString*)option table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    eventOptionsGoTableViewCell *new=[table dequeueReusableCellWithIdentifier:@"goCell"];
    new.option=option;
    [new.label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [new setSelectionStyle:UITableViewCellSelectionStyleNone];
    return new;
}

-(void)update
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
