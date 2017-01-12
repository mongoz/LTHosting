//
//  sliderViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventDetailViewController.h"

@interface sliderViewController : UIViewController

-(void)configureForOption:(NSString*)option;

@property eventDetailViewController *parent;

@property NSString *option;

-(void)prepareForSwitch;

-(void)setFrame:(CGRect)frame;

@end
