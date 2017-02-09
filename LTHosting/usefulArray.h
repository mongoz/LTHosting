//
//  usefulArray.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface usefulArray : NSArray

+(NSArray<NSString*>*)bodyFontPostScriptNames;

+(NSArray<UIFont*>*)bodyFontsWithSize:(CGFloat)size;

+(NSArray<UIImage*>*)borderImages;

+(NSArray<NSString*>*)borderNames;

+(NSDictionary<NSString*,UIImage*>*)borderImageNameDict;

@end
