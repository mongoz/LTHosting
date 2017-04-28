//
//  REAttributedStringItem.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "REAttributedStringItem.h"

@implementation REAttributedStringItem

-(id)init
{
    self=[super init];
    _attributedString=[[NSAttributedString alloc] init];
    _textInsets=UIEdgeInsetsMake(12.0f, 14.0f, 12.0f, 12.0f);
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}

-(id)initWithAttributedString:(NSAttributedString *)string
{
    self=[self init];
    _attributedString=string;
    return self;
}

-(id)initWithString:(NSString *)string font:(UIFont *)font
{
    self=[self init];
    _attributedString=[[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    return self;
}

+(REAttributedStringItem*)itemWithString:(NSString *)string font:(UIFont *)font
{
    return [[self alloc] initWithString:string font:font];
}

+(REAttributedStringItem*)itemWithAttributedString:(NSAttributedString *)string
{
    return [[self alloc] initWithAttributedString:string];
}

@end
