//
//  REAttributedStringCell.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "REAttributedStringCell.h"

@interface REAttributedStringCell(){
    UILabel *contentLabel;
}

@end

@implementation REAttributedStringCell

@dynamic item;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)cellDidLoad
{
    [super cellDidLoad];
    contentLabel=[[UILabel alloc] init];
    contentLabel.numberOfLines=0;
    [self addSubview:contentLabel];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)cellWillAppear
{
    [super cellWillAppear];
    [contentLabel setAttributedText:[(REAttributedStringItem*)self.item attributedString]];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIEdgeInsets insets=[(REAttributedStringItem*)self.item textInsets];
    [contentLabel setFrame:CGRectMake(insets.left, insets.top, frame.size.width-insets.left-insets.right, frame.size.height-insets.bottom-insets.top)];
}



+(CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    REAttributedStringItem *thisItem=(REAttributedStringItem*)item;
    CGFloat width=tableViewManager.tableView.frame.size.width;
    CGRect adjustedBounds=CGRectMake(0, 0, width-thisItem.textInsets.left-thisItem.textInsets.right, CGFLOAT_MAX);
    CGRect textRect=[thisItem.attributedString boundingRectWithSize:adjustedBounds.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
    return textRect.size.height+thisItem.textInsets.bottom+thisItem.textInsets.top;
}

@end
