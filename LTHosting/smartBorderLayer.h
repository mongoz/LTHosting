//
//  smartBorderLayer.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartLayer.h"

@interface smartBorderLayer : smartLayer

+(smartBorderLayer*)newSmartBorderInParentRect:(CGRect)parentrect;

@property (readonly, nonatomic) CGFloat defaultInset;

@property (readonly, nonatomic) CGFloat defaultCornerRadius;

@property (readonly, nonatomic) CGFloat defaultBorderWidth;

-(void)incrementInsetBy:(CGFloat)amount;

-(void)incrementBorderWidthBy:(CGFloat)amount;

-(void)incrementCornerRadiusBy:(CGFloat)amount;

@property (readwrite, nonatomic) CGFloat currentInset;

@end
