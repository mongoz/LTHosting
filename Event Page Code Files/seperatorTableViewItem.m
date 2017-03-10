//
//  seperatorTableViewItem.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "seperatorTableViewItem.h"

@implementation seperatorTableViewItem

-(id)init
{
    self=[super init];
    _color=[UIColor lightGrayColor];
    _height=12.0f;
    return self;
}

-(id)initWithColor:(UIColor *)color
{
    self=[self init];
    _color=color;
    return self;
}

-(id)initWithHeight:(CGFloat)height
{
    self=[self init];
    _height=height;
    return self;
}

-(id)initWithColor:(UIColor *)color height:(CGFloat)height
{
    self=[self initWithColor:color];
    _height=height;
    return self;
}

+(seperatorTableViewItem*)item
{
    return [[self alloc] init];
}

+(seperatorTableViewItem*)itemWithColor:(UIColor *)color height:(CGFloat)height
{
    return [[self alloc] initWithColor:color height:height];
}

+(seperatorTableViewItem*)itemWithColor:(UIColor *)color
{
    return [[self alloc] initWithColor:color];
}

+(seperatorTableViewItem*)itemWithHeight:(CGFloat)height
{
    return [[self alloc] initWithHeight:height];
}

@end
