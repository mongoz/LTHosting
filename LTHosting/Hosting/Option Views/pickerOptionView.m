//
//  pickerOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "pickerOptionView.h"
#import "stackView.h"


@interface pickerOptionView(){
    pickerOptionType type;
    
    NSArray<NSString*>* pickerData;
    
    UILabel *barLabel;
}
@end

@implementation pickerOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame type:(pickerOptionType)typ barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    type=typ;
    [self configureAccessoryView];
    return self;
}

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    type=LTPickerOptionMusic;
    [self configureAccessoryView];
    return self;
}

-(void)configureAccessoryView
{
    self.accessoryView=[[stackView alloc] initWithFrame:CGRectMake(0, self.barView.frame.origin.y+self.barView.frame.size.height, self.barView.frame.size.width, self.frame.size.height-self.barView.frame.size.height)];
    [self.accessoryView.layer setMasksToBounds:YES];
    UIPickerView *pick=[[UIPickerView alloc] initWithFrame:self.accessoryView.bounds];
    pick.delegate=self;
    pick.dataSource=self;
    
    [self.accessoryView addSubview:pick];
    
    [pick setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGFloat margin=8;
    barLabel=[[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.barView.frame.size.width-margin*2, self.barView.frame.size.height-margin*2)];
    if(type==LTPickerOptionMusic)
    {
        [self generateMusicList];
        [barLabel setText:@"Music"];
    }
    else if(type==LTPickerOptionVenue)
    {
        [self generateVenueList];
        [barLabel setText:@"Venue"];
    }
    [barLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    barLabel.textColor=[UIColor blackColor];
    [self.barView addSubview:barLabel];
    
    [self addArrangedSubview:self.accessoryView];
    self.accessoryView.hidden=YES;
    
    
}

-(pickerOptionType)toolType
{
    return type;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [barLabel setHidden:YES];
    [barLabel setText:[self pickerView:pickerView titleForRow:row forComponent:0]];
    [barLabel setHidden:NO];
    
}

-(BOOL)hasAccessoryView
{
    return YES;
}

-(void)generateMusicList
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"EDM"];
    [temp addObject:@"Rap"];
    [temp addObject:@"Hip Hop"];
    [temp addObject:@"Pop"];
    [temp addObject:@"Rock"];
    [temp addObject:@"Alternative"];
    [temp addObject:@"Latin"];
    [temp addObject:@"Other"];
    pickerData=[temp copy];
}

-(void)generateVenueList
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Bar"];
    [temp addObject:@"Club"];
    [temp addObject:@"Party"];
    [temp addObject:@"Event"];
    [temp addObject:@"Concert"];
    pickerData=[temp copy];
}

-(void)detailEditingWillEnd
{
    if(type==LTPickerOptionMusic)
    {
        if(![barLabel.text isEqualToString:@"Music"]){
            [[event sharedInstance] setMusic:barLabel.text];
        }
    }
    else if(type==LTPickerOptionVenue)
    {
        if(![barLabel.text isEqualToString:@"Venue"]){
            [[event sharedInstance] setVenue:barLabel.text];
        }
    }
}

-(BOOL)isComplete
{
    return YES;
}

-(NSString*)optionName
{
    switch(self.toolType)
    {
        case LTPickerOptionMusic:
            return @"Music";
        case LTPickerOptionVenue:
            return @"Venue";
    }
}

@end
