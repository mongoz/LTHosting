//
//  eventDetailViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"

@interface eventDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;

-(void)setTextOption:(NSString*)option;

@property (strong, nonatomic) IBOutlet UIView *slidingView;

@property (strong) event *creation;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

-(void)dismissSlider;

-(void)updateOption:(NSString*)option withSelection:(id)selection;

-(void)slideToNextSliderOption;

-(void)slideToPrevSliderOption;

@property (strong) NSString *selectedOption;

-(NSString*)lastSliderOption;

-(NSString*)firstSliderOption;

-(void)textViewTouched:(UITextView*)textView option:(NSString*)option;

-(void)addressDidBeginEditing:(NSString*)address;

-(void)addressDidChange:(NSString*)address;

-(void)addressDidEndEditing:(NSString*)address;

@property (strong, nonatomic) UITextView *tableTextView;

-(void)setTableTextView:(UITextView *)tableTextView;

-(UITextView*)getTableTextView;

-(void)completeAddressWithString:(NSString*)string;

-(NSArray<NSString*>*)determineUnSelectedOptions;

-(void)createCalloutForOptions:(NSArray<NSString*>*)options;

-(void)goPressed;


@end
