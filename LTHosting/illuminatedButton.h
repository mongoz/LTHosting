//
//  illuminatedButton.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol illuminatedButtonResponder;

@protocol illuminatedSource;

@interface illuminatedButton : UIButton

@property (strong, nonatomic) UIColor *illuminationColor;

@property (strong, nonatomic) UIColor *offColor;

@property (strong, nonatomic) UIColor *onTextColor;

@property (strong, nonatomic) UIColor *offTextColor;

@property BOOL illuminated;

@property (strong, nonatomic) id<illuminatedButtonResponder> responder;

@property (strong, nonnull, nonatomic) id<illuminatedSource> source;

-(void)changeState;

-(void)reloadData;

@end

@protocol illuminatedButtonResponder <NSObject>

@optional

-(void)illuminatedButton:(illuminatedButton* _Nonnull)button stateDidChangeTo:(BOOL)illuminated;

-(void)illuminatedButton:(illuminatedButton * _Nonnull)button stateWillChangeTo:(BOOL)illuminated;

@end

@protocol illuminatedSource <NSObject>

@required

-(NSString* _Nullable)offTitle;

-(NSString* _Nullable)onTitle;


@end
