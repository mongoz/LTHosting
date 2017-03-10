//
//  seperatorTableViewItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

@interface seperatorTableViewItem : RETableViewItem

@property (strong, nonatomic) UIColor *color;

@property (nonatomic) CGFloat height;

-(id)initWithColor:(UIColor*)color height:(CGFloat)height;

-(id)initWithColor:(UIColor*)color;

-(id)initWithHeight:(CGFloat)height;

+(seperatorTableViewItem*)item;

+(seperatorTableViewItem*)itemWithColor:(UIColor*)color height:(CGFloat)height;

+(seperatorTableViewItem*)itemWithColor:(UIColor*)color;

+(seperatorTableViewItem*)itemWithHeight:(CGFloat)height;

@end
