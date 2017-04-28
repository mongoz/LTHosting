//
//  event.h
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventComment.h"
#import "place.h"

@interface event : NSObject<NSCoding>

+(event*)sharedInstance;

+(void)setSharedInstance:(event*)existing;

+(void)resetSharedInstance;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) place *fullAddressInfo;

@property (strong, nonatomic) NSString *about;

@property (strong, nonatomic) NSDate *date;

@property BOOL isPrivate;

@property BOOL isFree;

@property (strong, nonatomic) NSString *music;

@property (strong, nonatomic) NSString *venue;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImage *flyer;

@property (strong, nonatomic) user *poster;

@property (strong, nonatomic) NSArray<eventComment*>* comments;

@property (strong, nonatomic) NSData *flyerObject;

@property (strong, nonatomic) NSMutableArray<user*>* attending;

@property (strong, nonatomic) NSMutableArray<user*>* requesting;

-(id)objectForOption:(NSString*)option;

-(void)print;

-(NSAttributedString*)flyerBodyForCurrentState;

-(NSString*)dateString;

@end
