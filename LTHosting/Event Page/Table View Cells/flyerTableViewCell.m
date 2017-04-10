//
//  flyerTableViewCell.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerTableViewCell.h"

@interface flyerTableViewCell(){
    UIImageView *imageView;
}

@end

@implementation flyerTableViewCell

@dynamic item;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(imageView!=nil)
    {
        [imageView setFrame:self.bounds];
    }
}

-(void)cellDidLoad
{
    [super cellDidLoad];
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:imageView];
}

-(void)cellWillAppear
{
    [super cellWillAppear];
    [imageView setImage:self.item.flyer];
}

+(CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    CGSize imageSize=[(flyerTableViewItem*)item flyer].size;
    return tableViewManager.tableView.frame.size.width*imageSize.height/imageSize.width;
}

@end
