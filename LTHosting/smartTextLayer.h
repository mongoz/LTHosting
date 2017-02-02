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

-(id)initWithParentRect:(CGRect)parentRect attributedString:(NSAttributedString*)string;

-(id)initWithParentRect:(CGRect)parentRect attributedString:(NSAttributedString*)string font:(UIFont*)font;

@property (strong, nonatomic) UILabel *textLayer;

@property (strong, nonatomic) UITextView *sourceTextView;

-(void)centerView;

-(NSTextAlignment)textAlignment;

-(void)setText:(NSString*)text;

@end
