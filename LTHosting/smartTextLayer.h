//
//  smartTextLayer.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smartLayer.h"

@interface smartTextLayer : smartLayer

+(smartTextLayer*)newSmartTextLayerInParentRect:(CGRect)parentRect withTextView:(UITextView*)textView;

@property (strong, nonatomic) UILabel *textLayer;

@property (strong, nonatomic) UITextView *sourceTextView;

-(void)centerView;

-(NSTextAlignment)textAlignment;

@end
