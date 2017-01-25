//
//  usefulArray.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "usefulArray.h"

@implementation usefulArray

+(NSArray<NSString*>*)bodyFontPostScriptNames
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"aliens and cows"];
    [temp addObject:@"Code Bold"];
    [temp addObject:@"Keep Calm"];
    [temp addObject:@"Nike Total 90"];
    [temp addObject:@"NOVA"];
    [temp addObject:@"PRIMETIME"];
    [temp addObject:@"TOMMY HILFIGER AF"];
    return [NSArray arrayWithArray:temp];
}

@end
