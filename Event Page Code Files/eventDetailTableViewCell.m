//
//  eventDetailTableViewCell.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventDetailTableViewCell.h"

@interface eventDetailTableViewCell(){
    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *leftImage;
    UIImageView *rightImage;
    UIView *divider;
}

@end

@implementation eventDetailTableViewCell

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
    return 64.0f;
}

-(void)cellDidLoad
{
    [super cellDidLoad];
    leftLabel=[[UILabel alloc] init];
    leftLabel.numberOfLines=0;
    rightLabel=[[UILabel alloc] init];
    rightLabel.numberOfLines=0;
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    leftLabel.textAlignment=NSTextAlignmentLeft;
    [rightLabel setTextAlignment:NSTextAlignmentRight];
    leftImage=[[UIImageView alloc] init];
    leftImage.contentMode=UIViewContentModeScaleAspectFit;
    rightImage=[[UIImageView alloc] init];
    rightImage.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:leftImage];
    [self addSubview:rightImage];
    
    divider=[[UIView alloc] init];
    divider.backgroundColor=[UIColor blackColor];
    [self addSubview:divider];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat margin=8.0f;
    CGFloat dividerWidth=1.0f;
    CGRect leftRect=CGRectMake(0, 0, (self.frame.size.width-dividerWidth)/2.0f, self.frame.size.height);
    CGFloat height=leftRect.size.height-margin*2;
    leftImage.frame=CGRectMake(margin, margin, height, height);
    leftLabel.frame=CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+margin, leftImage.frame.origin.y, leftRect.size.width-margin*3-leftImage.frame.size.width, leftImage.frame.size.height);
    divider.frame=CGRectMake(leftRect.size.width, margin, dividerWidth, height);
    rightImage.frame=CGRectMake(self.frame.size.width-height-margin, margin, height, height);
    rightLabel.frame=CGRectMake(divider.frame.origin.x+divider.frame.size.width, rightImage.frame.origin.y, leftRect.size.width-margin*3-rightImage.frame.size.width, rightImage.frame.size.height);
    CGFloat prop=1/1.618;
    [self scaleView:rightImage by:prop];
    [self scaleView:leftImage by:prop];
}

-(void)scaleView:(UIView*)view by:(CGFloat)scale
{
    CGSize newSize=CGSizeMake(view.frame.size.width*scale, view.frame.size.height*scale);
    view.frame=CGRectMake(view.frame.origin.x+view.frame.size.width/2-newSize.width/2, view.frame.origin.y+view.frame.size.height/2-newSize.height/2, newSize.width, newSize.height);
}

-(void)cellWillAppear
{
    [super cellWillAppear];
    CLLocation *me=[self.item.locationManager location];
    CLLocationCoordinate2D place2D=[[self.item.event fullAddressInfo] coordinate];
    CLLocation *place=[[CLLocation alloc] initWithLatitude:place2D.latitude longitude:place2D.longitude];
    CLLocationDistance dist=[place distanceFromLocation:me];
    [rightLabel setText:[self stringForDistance:dist]];
    NSTimeInterval timeUntilEvent=[self.item.event.date timeIntervalSinceNow];
    [leftLabel setText:[self stringForInterval:timeUntilEvent]];
    
    leftImage.image=[UIImage imageNamed:@"hourglass.png"];
    rightImage.image=[UIImage imageNamed:@"location-pointer.png"];
}

-(NSString*)stringForInterval:(NSTimeInterval)interval
{
    if(interval<0)
    {
        return @"Happening Now";
    }
    NSInteger hours=MAX(round(interval/3600),0);
    switch(hours)
    {
        case 0:{
            NSInteger minutes=round(interval/60);
            if(minutes==0)
            {
                return @"Happening Now";
            }
            return [NSString stringWithFormat:@"In %ld minutes",(long)minutes];
        }
        case 1:
            return [NSString stringWithFormat:@"In %ld hour",(long)hours];
        default:
            return [NSString stringWithFormat:@"In %ld hours",(long)hours];
    }
}

-(NSString*)stringForDistance:(CLLocationDistance)distance
{
    NSInteger miles=round([self milesFromMeters:distance]);
    switch(miles)
    {
        case 0:{
            NSInteger feet=[self feetFromMeters:distance];
            feet=round(feet/3);
            return [NSString stringWithFormat:@"%ld yards away",feet];
        }
        case 1:
            return [NSString stringWithFormat:@"%ld mile away",miles];
        default:
            return [NSString stringWithFormat:@"%ld miles away",miles];
    }
}

-(CGFloat)feetFromMeters:(CGFloat)meters
{
    return round(meters*3.28);
}

-(CGFloat)milesFromFeet:(CGFloat)feet
{
    return feet/5280.0f;
}

-(CGFloat)milesFromMeters:(CGFloat)meters
{
    return [self milesFromFeet:[self feetFromMeters:meters]];
}


@end
