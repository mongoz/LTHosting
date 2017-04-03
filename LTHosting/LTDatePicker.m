//
//  LTDatePicker.m
//  datePicker
//
//  Created by Cam Feenstra on 2/14/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTDatePicker.h"

@interface LTDatePicker(){
    BOOL isReloading;
    NSInteger screenCount;
    BOOL hasCount;
    
    UIFont *font;
    
    
    NSInteger initialHourSelection;
    NSInteger initialMinuteSelection;
}

@end

@implementation LTDatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    _picker=[[UIPickerView alloc] initWithFrame:self.bounds];
    _picker.delegate=self;
    _picker.dataSource=self;
    [self addSubview:_picker];
    font=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    initialHourSelection=0;
    initialMinuteSelection=0;
    return self;
}

-(id)init
{
    self=[super init];
    screenCount=0;
    hasCount=NO;
    _picker=[[UIPickerView alloc] init];
    _picker.delegate=self;
    _picker.dataSource=self;
    [self addSubview:_picker];
    font=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self reloadAllComponents];
    for(NSInteger i=1; i<3; i++)
    {
        [_picker selectRow:[self pickerView:_picker numberOfRowsInComponent:i]/2 inComponent:i animated:NO];
    }
    [_picker selectRow:0 inComponent:0 animated:NO];
}

-(void)reloadAllComponents
{
    [_picker reloadAllComponents];
    [self setDate:[NSDate date] animated:NO silent:YES];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_picker setFrame:self.bounds];
}

//UIPickerViewDataSource Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==3)
    {
        return 2;
    }
    return 1000;
}

//UIPickerViewDelegate Methods

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [self pickerScrollingDidBeginInComponent:component atRow:[_picker selectedRowInComponent:component]];
    NSAttributedString *finalString;
    switch(component){
        case 0:
        {
            finalString= [[NSAttributedString alloc] initWithString:[self dayForRow:row]];
            break;
        }
        case 1:
        {
            finalString= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self hourForRow:row]]];
            break;
        }
        case 2:
        {
            finalString= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld",[self minuteForRow:row]]];
            break;
        }
        case 3:
        {
            switch(row)
            {
                case 0:
                    finalString= [[NSAttributedString alloc] initWithString:@"AM"];
                    break;
                case 1:
                    finalString= [[NSAttributedString alloc] initWithString:@"PM"];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
        {
            finalString= [[NSAttributedString alloc] init];
            break;
        }
    }
    UILabel *rowLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self pickerView:pickerView widthForComponent:component], 32)];
    rowLabel.attributedText=finalString;
    [rowLabel setFont:font];
    rowLabel.textAlignment=NSTextAlignmentRight;
    return rowLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat refWidth=pickerView.frame.size.width-64;
    if(component==0)
    {
        NSAttributedString *att=[[NSAttributedString alloc] initWithString:@"Wed 15 Feb" attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
        return att.size.width*1.1f;
    }
    return refWidth/6.0f;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return font.lineHeight;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self pickerScrollingDidEndInComponent:component atRow:[_picker selectedRowInComponent:component]];
}

-(void)pickerScrollingDidBeginInComponent:(NSInteger)component atRow:(NSInteger)row
{
    if(component==1)
    {
        if(initialHourSelection==0)
        {
            initialHourSelection=row;
        }
    }
    else if(component==2)
    {
        if(initialMinuteSelection==0)
        {
            initialMinuteSelection=row;
        }
    }
}

-(void)pickerScrollingDidEndInComponent:(NSInteger)component atRow:(NSInteger)row
{
    if(component==1)
    {
        NSInteger total=[self hourForRow:initialHourSelection]+row-initialHourSelection;
        if([self hourForRow:initialHourSelection]==12)
        {
            total-=12;
        }
        if(total>0)
        {
            while(total>11)
            {
                total-=12;
                [self incrementAMPMUp:YES];
            }
            
        }
        else if(total<0)
        {
            while(total<0)
            {
                total+=12;
                [self incrementAMPMUp:NO];
            }
        }
        initialHourSelection=0;
    }
    else if(component==2)
    {
        NSInteger total=[self minuteForRow:initialMinuteSelection]+row-initialMinuteSelection;
        if(total>0)
        {
            while(total>59)
            {
                total-=60;
                [self incrementHourUp:YES];
            }
        }
        else if(total<0)
        {
            while(total<0)
            {
                total+=60;
                [self incrementHourUp:NO];
            }
        }
        initialMinuteSelection=0;
    }
    if(_delegate!=nil)
    {
        [_delegate datePicker:self dateDidChangeTo:[self date]];
    }
}

-(NSInteger)minuteForRow:(NSInteger)row
{
    return row%60;
}

-(NSInteger)hourForRow:(NSInteger)row
{
    return row%12+1;
}

-(NSDate*)dateForRow:(NSInteger)row
{
    return [NSDate dateWithTimeInterval:(row*24*60*60) sinceDate:[NSDate date]];
}

-(NSString*)dayForRow:(NSInteger)row
{
    if(row==0)
    {
        return @"Today";
    }
    NSDate *thisDate=[self dateForRow:row];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"EEE d MMM"];
    return [format stringFromDate:thisDate];
}

//Retrieve Date
-(NSDate*)date
{
    NSDateComponents *newComps=[[NSDateComponents alloc] init];
    NSDateComponents *dayComps=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[self dateForRow:[_picker selectedRowInComponent:0]]];
    newComps.year=dayComps.year;
    newComps.month=dayComps.month;
    newComps.day=dayComps.day;
    newComps.hour=[self hourForRow:[_picker selectedRowInComponent:1]];
    newComps.minute=[self minuteForRow:[_picker selectedRowInComponent:2]];
    if([_picker selectedRowInComponent:3]==1)
    {
        newComps.hour+=12;
    }
    return [[NSCalendar currentCalendar] dateFromComponents:newComps];
}

-(void)setDay:(NSDate*)day
{
    NSDateComponents *comps=[[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:day];
    for(NSInteger i=0; i<[self pickerView:_picker numberOfRowsInComponent:0]; i++)
    {
        NSDateComponents *these=[[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[self dateForRow:i]];
        if(these.day==comps.day&&these.month==comps.month&&these.year==comps.year)
        {
            [_picker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

-(void)incrementAMPMUp:(BOOL)up
{
    if(up)
    {
        if([_picker selectedRowInComponent:3]==1)
        {
            [_picker selectRow:MIN([_picker selectedRowInComponent:0]+1,[self pickerView:_picker numberOfRowsInComponent:0]-1) inComponent:0 animated:YES];
        }
    }
    else
    {
        if([_picker selectedRowInComponent:3]==0)
        {
            [_picker selectRow:MAX([_picker selectedRowInComponent:0]-1,0) inComponent:0 animated:YES];
        }
    }
    [_picker selectRow:([_picker selectedRowInComponent:3]+1)%2 inComponent:3 animated:YES];
}

-(void)incrementHourUp:(BOOL)up
{
    [self pickerScrollingDidBeginInComponent:1 atRow:[_picker selectedRowInComponent:1]];
    if(up)
    {
        [_picker selectRow:MIN([_picker selectedRowInComponent:1]+1,[self pickerView:_picker numberOfRowsInComponent:1]-1) inComponent:1 animated:YES];
    }
    else
    {
        [_picker selectRow:MAX([_picker selectedRowInComponent:1]-1,0) inComponent:1 animated:YES];
    }
    [self pickerScrollingDidEndInComponent:1 atRow:[_picker selectedRowInComponent:1]];
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setDate:date animated:animated silent:NO];
}

-(void)setDate:(NSDate*)date animated:(BOOL)animated silent:(BOOL)silent{
    NSDateComponents *comps=[[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    for(NSInteger i=1; i<3; i++)
    {
        [_picker selectRow:[self pickerView:_picker numberOfRowsInComponent:i]/2 inComponent:i animated:NO];
    }
    NSInteger ind=0;
    if(comps.hour>12)
    {
        ind=1;
        comps.hour-=12;
    }
    NSInteger dayIndex=0;
    for(NSInteger i=0; i<[self pickerView:_picker numberOfRowsInComponent:0]; i++)
    {
        NSDateComponents *tComps=[[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[self dateForRow:i]];
        if(tComps.day==comps.day&&tComps.month==comps.month&&tComps.year==comps.year)
        {
            dayIndex=i;
            break;
        }
    }
    NSInteger minuteIndex=[_picker selectedRowInComponent:2];
    if([self minuteForRow:minuteIndex]!=comps.minute)
    {
        for(NSInteger i=0; i<[self pickerView:_picker numberOfRowsInComponent:2]; i++)
        {
            if([self minuteForRow:(minuteIndex+i)%[self pickerView:_picker numberOfRowsInComponent:2]]==comps.minute)
            {
                minuteIndex=(minuteIndex+i)%[self pickerView:_picker numberOfRowsInComponent:2];
                break;
            }
        }
    }
    NSInteger hourIndex=[_picker selectedRowInComponent:1];
    if([self hourForRow:hourIndex]!=comps.hour)
    {
        for(NSInteger i=0; i<[self pickerView:_picker numberOfRowsInComponent:1]; i++)
        {
            if([self hourForRow:(hourIndex+i)%[self pickerView:_picker numberOfRowsInComponent:1]]==comps.hour)
            {
                hourIndex=(hourIndex+i)%[self pickerView:_picker numberOfRowsInComponent:1];
                break;
            }
        }
    }
    [_picker selectRow:dayIndex inComponent:0 animated:animated];
    [_picker selectRow:hourIndex inComponent:1 animated:animated];
    initialHourSelection=[_picker selectedRowInComponent:1];
    [_picker selectRow:minuteIndex inComponent:2 animated:animated];
    initialMinuteSelection=[_picker selectedRowInComponent:2];
    [_picker selectRow:ind inComponent:3 animated:animated];
    
    if(self.delegate!=nil&&!silent)
    {
        [_delegate datePicker:self dateDidChangeTo:[self date]];
    }
}

//Set delegate methods
-(void)setDelegate:(id<LTDatePickerDelegate>)delegate
{
    _delegate=delegate;
}

//Overriding appearance methods to apply to picker in addition to the container view
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [_picker setBackgroundColor:backgroundColor];
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [_picker setTintColor:tintColor];
}

-(void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    [_picker setAlpha:alpha];
}

//Font methods
-(UIFont*)font
{
    return font;
}

-(void)setFont:(UIFont *)fonta
{
    font=fonta;
    [self reloadAllComponents];
}
@end
