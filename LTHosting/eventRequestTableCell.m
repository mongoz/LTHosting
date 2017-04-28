//
//  eventRequestTableCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventRequestTableCell.h"

@implementation eventRequestTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    _profileImageView.layer.masksToBounds=YES;
    [_profileImageView setContentMode:UIViewContentModeScaleAspectFill];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _profileImageView.layer.cornerRadius=_profileImageView.frame.size.height/2;
}

@end
