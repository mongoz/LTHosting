//
//  dateSliderViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "dateSliderViewController.h"

@interface dateSliderViewController () {
    NSDate *selection;
}
@end

@implementation dateSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [_leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [_datePickerView addGestureRecognizer:_leftSwipeRecognizer];
    [_datePickerView addGestureRecognizer:_rightSwipeRecognizer];
    [_datePickerView setMinimumDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)donePressed:(id)sender
{
    [self updateParent];
    [self.parent dismissSlider];
}

-(IBAction)prevPressed:(id)sender
{
    [self updateParent];
    [self.parent slideToPrevSliderOption];
}

-(IBAction)nextPressed:(id)sender
{
    [self updateParent];
    [self.parent slideToNextSliderOption];
}

-(IBAction)swipedLeft:(id)sender
{
    [self nextPressed:nil];
}

-(IBAction)swipedRight:(id)sender
{
    [self prevPressed:nil];
}

-(void)configureForOption:(NSString *)option
{
    self.option=option;
    NSDate *selectedDate=self.parent.creation.date;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_titleLabel setText:option];
        [_datePickerView setDate:selectedDate animated:NO];
    }];
}

-(void)prepareForSwitch
{
    [self updateParent];
}

-(void)updateParent
{
    [self.parent updateOption:self.option withSelection:_datePickerView.date];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [_datePickerView setFrame:pickerFrame];
    }];
}

@end
