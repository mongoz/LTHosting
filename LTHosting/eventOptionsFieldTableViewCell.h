//
//  eventOptionsFieldTableViewCell.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventOptionTableViewCell.h"

@interface eventOptionsFieldTableViewCell : eventOptionTableViewCell <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textBox;

@property (strong) NSString *placeholderText;

@property (strong) NSString *content;

-(void)completeAddress:(NSString*)address;

@end
