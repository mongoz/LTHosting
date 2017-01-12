//
//  pickerSliderViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "pickerSliderViewController.h"

@interface pickerSliderViewController (){
    NSString *sliderOption;
    
    NSArray<NSString*> *pickerData;
}
@end

@implementation pickerSliderViewController

- (void)viewDidLoad {
    _pickerView.dataSource=self;
    _pickerView.delegate=self;
    [super viewDidLoad];
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [_titleLabel setText:@"test"];
    [_leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [_leftSwipeRecognizer setNumberOfTouchesRequired:1];
    [_rightSwipeRecognizer setNumberOfTouchesRequired:1];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)donePressed:(id)sender {
    NSString *selected=pickerData[[_pickerView selectedRowInComponent:0]];
    [self.parent updateOption:sliderOption withSelection:selected];
    [self.parent dismissSlider];
}

-(NSString*)getSelected
{
    NSString *selected=pickerData[[_pickerView selectedRowInComponent:0]];
    return selected;
}

-(void)updateParent;
{
    [self.parent updateOption:sliderOption withSelection:[self getSelected]];
}

- (IBAction)nextPressed:(id)sender {
    [self updateParent];
    [self.parent slideToNextSliderOption];
}

- (IBAction)prevPressed:(id)sender {
    [self updateParent];
    [self.parent slideToPrevSliderOption];
    
}

-(void)configureForOption:(NSString *)option
{
    sliderOption=option;
    self.option=option;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_titleLabel setText:option];
    }];
    if([sliderOption isEqualToString:@"Music"])
    {
        [self generateMusicList];
    }
    else if([sliderOption isEqualToString:@"Venue"])
    {
        [self generateVenueList];
    }
    [_pickerView reloadAllComponents];
    NSString *currentSelect=(NSString*)[self.parent.creation objectForOption:option];
    NSInteger select=0;
    if([pickerData containsObject:currentSelect])
    {
        select=[pickerData indexOfObject:currentSelect];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_pickerView selectRow:select inComponent:0 animated:NO];
    }];
}

//Functions to generate arrays to populate picker

-(void)generateMusicList
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Classical"];
    [temp addObject:@"Latin"];
    [temp addObject:@"Jazz"];
    [temp addObject:@"EDM"];
    [temp addObject:@"Rap"];
    [temp addObject:@"Hip Hop"];
    [temp addObject:@"Rock"];
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

//Picker View Delegate/Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

//Prepare to switch to another option slider
-(void)prepareForSwitch
{
    NSString *selected=pickerData[[_pickerView selectedRowInComponent:0]];
    [self.parent updateOption:sliderOption withSelection:selected];
}

- (IBAction)swipedRight:(id)sender {
    [self prevPressed:nil];
}
- (IBAction)swipedLeft:(id)sender {
    [self nextPressed:nil];
}

//Set Frame to preserve constraints
-(void)setFrame:(CGRect)frame
{
    CGRect viewFrame=frame;
    CGFloat barHeight=52;
    //CGFloat buttonMargins=8;
    CGRect barFrame=CGRectMake(0, 0, viewFrame.size.width, barHeight);
    CGRect pickerFrame=CGRectMake(0, barHeight, viewFrame.size.width, viewFrame.size.height-barHeight);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.view setFrame:frame];
        [_barView setFrame:barFrame];
        [_pickerView setFrame:pickerFrame];
    }];
}
@end
