
//
//  datePickerOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "datePickerOptionView.h"
#import "stackDatePicker.h"
#import "stackView.h"

@interface datePickerOptionView(){
    UILabel *dateLabel;
    UIImageView *imageView;
    LTDatePicker *pick;
    
    NSDate *currentDate;
}
@end

@implementation datePickerOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    currentDate=[NSDate date];
    imageView=[[UIImageView alloc] init];
    [self configureAccessoryView];
    return self;
}

-(BOOL)hasAccessoryView
{
    return YES;
}

-(void)setOptionImage:(UIImage *)optionImage{
    [super setOptionImage:optionImage];
    imageView.image=self.optionImage;
}

-(void)configureAccessoryView
{
    self.accessoryView=[[stackView alloc] initWithFrame:CGRectMake(self.barView.frame.origin.x, self.barView.frame.size.height+self.barView.frame.origin.y, self.barView.frame.size.width, self.bounds.size.height-self.barView.frame.size.height)];
    [self.accessoryView.layer setShadowColor:self.barView.layer.shadowColor];
    [self.accessoryView.layer setShadowRadius:self.barView.layer.shadowRadius];
    [self.accessoryView.layer setShadowOpacity:self.barView.layer.shadowOpacity];
    pick=[[LTDatePicker alloc] initWithFrame:self.accessoryView.bounds];
    pick.delegate=self;
    [pick setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [pick setDate:currentDate animated:NO];
    //[pick addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventPrimaryActionTriggered];
    //[pick setMinimumDate:[NSDate date]];
    [self.accessoryView addSubview:pick];
    [self addArrangedSubview:self.accessoryView];
    self.accessoryView.hidden=YES;
    [self.accessoryView.layer setMasksToBounds:YES];
    CGFloat margin=8;
    CGFloat height=self.barView.frame.size.height-margin*2;
    imageView.frame=CGRectMake(margin, margin, height, height);
    
    void (^scaleBy)(UIView *v, CGFloat scale)=^(UIView *v, CGFloat scale){
        CGPoint center=v.center;
        [v setBounds:CGRectMake(0, 0, v.frame.size.width*scale, v.frame.size.height*scale)];
        v.center=center;
    };
    dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+margin,margin,self.barView.frame.size.width-margin*3-height, height)];
    scaleBy(imageView,.75f);
    [dateLabel setText:@"What Time?"];
    [dateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [dateLabel setTextColor:[UIColor lightGrayColor]];
    [self.barView addSubview:dateLabel];
    [self.barView addSubview:imageView];
}

-(NSString*)stringForDate:(NSDate*)date
{
    NSDateComponents *comp=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitSecond) fromDate:date];
    NSDateComponents *now=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitSecond) fromDate:[NSDate date]];
    if(comp.hour%12==0)
    {
        date=[date dateByAddingTimeInterval:-12*60*60];
    }
    
    NSTimeInterval interval=[date timeIntervalSinceNow];
    
    NSTimeInterval effectiveTime=ceil(interval-(comp.hour*60*60)-comp.minute*60-comp.second+(now.hour*60*60)+now.minute*60+now.second);
    effectiveTime=effectiveTime/(24*60*60);
    if(effectiveTime<1)
    {
        CGFloat hours=interval/(60*60);
        CGFloat extra=0;
        if(hours-floor(hours)<=.25)
        {
            extra=0;
        }
        else if(hours-floor(hours)>.25&&hours-floor(hours)<.75)
        {
            extra=.5;
        }
        else if(hours-floor(hours)>=.75)
        {
            extra=1;
        }
        hours=floor(hours)+extra;
        NSString *hourText;
        if(hours==0)
        {
            return @"Now";
        }
        if(hours==1)
        {
            hourText=@"1 Hour";
        }
        else
        {
            if(hours!=floor(hours))
            {
                hourText=[NSString stringWithFormat:@"%.01f Hours",(double)hours];
            }
            else
            {
                hourText=[NSString stringWithFormat:@"%.f Hours",(double)hours];
            }
        }
        return [NSString stringWithFormat:@"In %@",hourText];
    }
    else if(effectiveTime>=1&&effectiveTime<2)
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm a"];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        return [NSString stringWithFormat:@"Tomorrow, %@",[formatter stringFromDate:date]];
    }
    else if(effectiveTime>=2&&effectiveTime<7)
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"EEEE, h:mm a"];
        return [formatter stringFromDate:date];
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"M/dd, h:mm a"];
        return [formatter stringFromDate:date];
    }
}

-(void)tapBar
{
    /*stackDatePicker *pic=nil;
    for(UIView *v in self.barView.subviews)
    {
        if(v.class==[stackDatePicker class])
        {
            pic=(stackDatePicker*)v;
        }
    }*/
    [super tapBar];
}

-(void)detailEditingWillEnd
{
    [[event sharedInstance] setDate:currentDate];
}

//LTDatePickerDelegate method
-(void)datePicker:(LTDatePicker *)picker dateDidChangeTo:(NSDate *)date
{
    NSString *newText=[self stringForDate:date];
    if(newText!=dateLabel.text)
    {
        dateLabel.alpha=0.0f;
        [dateLabel setText:[self stringForDate:[picker date]]];
        dateLabel.textColor=[UIColor blackColor];
        currentDate=[picker date];
        dateLabel.alpha=1.0f;
    }
    if([date timeIntervalSinceNow]<0&&fabs([date timeIntervalSinceNow])>60)
    {
        [picker setDate:[NSDate date] animated:YES];
    }
    
}

-(BOOL)isComplete
{
    if([dateLabel.text isEqualToString:@"What Time?"]){
        return NO;
    }
    return YES;
}

-(NSString*)optionName
{
    return @"Date";
}

@end
