//
//  dateSliderViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "sliderViewController.h"

@interface dateSliderViewController : sliderViewController 

@property (strong, nonatomic) IBOutlet UIView *barView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)donePressed:(id)sender;

- (IBAction)nextPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)swipedRight:(id)sender;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;

- (IBAction)swipedLeft:(id)sender;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;

- (IBAction)prevPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end
