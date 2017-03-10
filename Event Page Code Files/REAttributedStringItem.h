//
//  REAttributedStringItem.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

@interface REAttributedStringItem : RETableViewItem

@property (strong, nonatomic) NSAttributedString *attributedString;

@property (nonatomic) UIEdgeInsets textInsets;

-(id)initWithAttributedString:(NSAttributedString*)string;

-(id)initWithString:(NSString*)string font:(UIFont*)font;

+(REAttributedStringItem*)itemWithAttributedString:(NSAttributedString*)string;

+(REAttributedStringItem*)itemWithString:(NSString*)string font:(UIFont*)font;

@end
