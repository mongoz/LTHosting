//
//  eventComment.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface eventComment : NSObject

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSDate *postingDate;

@property (strong, nonatomic) user *poster;

@end
