//
//  event.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GooglePlaces;

@interface event : NSObject

+(event*)sharedInstance;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *about;

@property (strong, nonatomic) NSDate *date;

@property BOOL isPrivate;

@property BOOL isFree;

@property (strong, nonatomic) NSString *music;

@property (strong, nonatomic) NSString *venue;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImage *flyer;

-(id)objectForOption:(NSString*)option;

-(void)print;

-(NSAttributedString*)flyerBodyForCurrentState;

@end
