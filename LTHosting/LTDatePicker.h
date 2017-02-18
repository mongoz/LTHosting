//
//  LTDatePicker.h
//  datePicker
//
//  Created by Cam Feenstra on 2/14/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTDatePickerDelegate;

@interface LTDatePicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *picker;

-(NSDate*)date;

-(void)setDate:(NSDate*)date animated:(BOOL)animated;

@property (nonatomic) id<LTDatePickerDelegate> delegate;

-(UIFont*)font;

-(void)setFont:(UIFont*)font;

@end

@protocol LTDatePickerDelegate <NSObject>

-(void)datePicker:(LTDatePicker*)picker dateDidChangeTo:(NSDate*)date;

@end
