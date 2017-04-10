//
//  seperatorCell.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "seperatorCell.h"

@implementation seperatorCell

@dynamic item;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return [(seperatorTableViewItem*)item height];
}

-(void)cellDidLoad
{
    [super cellDidLoad];
}

-(void)cellWillAppear
{
    [super cellWillAppear];
    [self setBackgroundColor:self.item.color];
}

@end
