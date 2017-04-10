//
//  keyboardAccessory.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum types{
    dismissAccessory
}keyboardAccessoryType;

@interface keyboardAccessory : UIView

-(id)initWithWidth:(CGFloat)width;

@property (strong, nonatomic) void(^dismissBlock)(keyboardAccessory*);

@property (readwrite, nonatomic) keyboardAccessoryType accessoryType;

-(id)initWithType:(keyboardAccessoryType)type width:(CGFloat)width;

+(keyboardAccessory*)accessoryWithType:(keyboardAccessoryType)tye width:(CGFloat)width;

@end
