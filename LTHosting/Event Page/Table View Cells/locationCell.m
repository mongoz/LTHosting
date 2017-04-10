//
//  locationCell.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "locationCell.h"

@interface locationCell(){
    UIImageView *imageView;
    UILabel *label;
    CGFloat margin;
    BOOL hasPlace;
}

@end

@implementation locationCell

@dynamic item;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self=[super init];
    margin=8.0f;
    hasPlace=NO;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat height=frame.size.height-margin*2;
    imageView.frame=CGRectMake(margin, margin, height, height);
    label.frame=CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+margin, margin, frame.size.width-margin*3-height, height);
    [self scaleView:imageView by:0.5f];
    
}

-(void)scaleView:(UIView*)view by:(CGFloat)scale
{
    CGSize newSize=CGSizeMake(view.frame.size.width*scale, view.frame.size.height*scale);
    view.frame=CGRectMake(view.frame.origin.x+view.frame.size.width/2-newSize.width/2, view.frame.origin.y+view.frame.size.height/2-newSize.height/2, newSize.width, newSize.height);
}

-(void)cellDidLoad
{
    [super cellDidLoad];
    imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location-pointer.png"]];
    label=[[UILabel alloc] init];
    [self addSubview:imageView];
    [self addSubview:label];
}

-(void)cellWillAppear
{
    [super cellWillAppear];
    if(self.item.place==nil)
    {
        [imageView setAlpha:0.5f];
    }
    else
    {
        [imageView setAlpha:1.0f];
    }
    [label setAttributedText:[[NSAttributedString alloc] initWithString:self.item.addressString attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}]];
}

+(CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    CGFloat margin=8.0f;
    locationItem *myItem=(locationItem*)item;
    NSAttributedString *labelString=[[NSAttributedString alloc] initWithString:myItem.addressString attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    BOOL oneWorks=NO;
    CGFloat imageHeight=[UIFont preferredFontForTextStyle:UIFontTextStyleBody].lineHeight*2;
    CGFloat width=tableViewManager.tableView.frame.size.width-margin*2;
    if(width<=0)
    {
        return 64;
    }
    while(!oneWorks)
    {
        if(imageHeight>width)
        {
            return 64;
        }
        CGRect bounding=[labelString boundingRectWithSize:CGSizeMake(width-imageHeight-margin, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
        if(bounding.size.height<=imageHeight)
        {
            oneWorks=YES;
        }
        else
        {
            imageHeight++;
        }
    }
    return imageHeight+margin*2;
}

@end
