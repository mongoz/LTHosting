//
//  pickerSliderViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sliderViewController.h"

@interface pickerSliderViewController : sliderViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *barView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UIButton *prevButton;


@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)donePressed:(id)sender;

- (IBAction)nextPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)swipedRight:(id)sender;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;

- (IBAction)swipedLeft:(id)sender;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;

- (IBAction)prevPressed:(id)sender;

@end
