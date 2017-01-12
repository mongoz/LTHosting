//
//  eventOptionsImageTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/5/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionsImageTableViewCell.h"

@interface eventOptionsImageTableViewCell(){
    
}
@end

@implementation eventOptionsImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(eventOptionTableViewCell*)cellForOption:(NSString *)option table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    eventOptionsImageTableViewCell *new=[table dequeueReusableCellWithIdentifier:@"imageOptionCell"];
    new.textLabel.text=@"Add Flyer";
    [new.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    new.option=option;
    if(![parent.creation.image isEqual:[[UIImage alloc] init]])
    {
        new.eventImage=parent.creation.flyer;
        new.sourceImage=parent.creation.image;
        [new.imageView setImage:parent.creation.flyer];
    }
    else
    {
        new.eventImage=[[UIImage alloc] init];
        new.sourceImage=[[UIImage alloc] init];
    }
    return new;
}

-(void)update
{
    [self.parent updateOption:@"Image" withSelection:_sourceImage];
    [self.parent updateOption:@"Flyer" withSelection:_eventImage];
}

@end
