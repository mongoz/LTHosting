//
//  eventOptionVIew.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"
#import <ChameleonFramework/Chameleon.h>
#import "commonUseFunctions.h"

@protocol eventOptionViewDelegate;

@interface eventOptionView : UIStackView <UIGestureRecognizerDelegate>

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight;

@property (strong, nonatomic) UIView *barView;

@property (strong, nonatomic) UIView *accessoryView;

-(BOOL)hasAccessoryView;

-(BOOL)isAccessoryViewShowing;

-(void)tapBar;

@property (strong, nonatomic) id<eventOptionViewDelegate> myDelegate;

-(UIView*)inputAccessoryView;

-(void)detailEditingWillEnd;

@property CGFloat barHeight;

@end

@protocol eventOptionViewDelegate <NSObject>

@optional

-(void)accessoryShowingDidChangeForEventOptionView:(eventOptionView*)view;

-(void)accessoryShowingWillChangeForEventOptionView:(eventOptionView*)view;

-(void)goWasPressed;

@end
