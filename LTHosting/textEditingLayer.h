//
//  textEditingLayer.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "editingLayer.h"

@interface textEditingLayer : editingLayer

@property (strong, nonatomic) CATextLayer *textLabel;

-(CGFloat)maxTextSize;

-(void)autoAdjustFontSize;

@property BOOL flexibleHeight;

@property UIFont *font;

@property (nonatomic) NSString *text;

@property (readonly) NSAttributedString *attributedText;

@property (nonatomic) NSTextAlignment textAlignment;

@end
