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

+(NSArray<UIImage*>*)borderImages
{
    static NSArray *ret=nil;
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border4 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border5 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border12 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border14 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border15 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"border17 copy"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"fireborder"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"pizzaborder"]];
    ret=temp;
    return ret;
}

+(UIImage*)imageWithContentsOfFileWithName:(NSString*)filename
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@".png"]];
}

+(NSArray<NSString*>*)borderNames
{
    static NSArray *ret=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        [temp addObject:@"Aztec"];
        [temp addObject:@"Checker"];
        [temp addObject:@"Sublime"];
        [temp addObject:@"Pointer"];
        [temp addObject:@"Arrows"];
        [temp addObject:@"Memory"];
        [temp addObject:@"Fire"];
        [temp addObject:@"Pizza"];
        ret=temp;
    });
    return ret;
}

+(NSDictionary<NSString*,UIImage*>*)borderImageNameDict
{
    static NSDictionary *ret=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *names=[self borderNames];
        NSArray *images=[self borderImages];
        NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
        for(NSInteger i=0; i<names.count; i++)
        {
            [temp setObject:images[i] forKey:names[i]];
        }
        ret=temp;
    });
    return ret;
}

@end
