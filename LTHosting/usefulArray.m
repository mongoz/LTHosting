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
    [temp addObject:@"System"];
    [temp addObject:@"Bebas Neue"];
    [temp addObject:@"BullpenHv-Italic"];
    [temp addObject:@"Chosence-BoldItalic"];
    [temp addObject:@"Comfortaa"];
    [temp addObject:@"Hero"];
    [temp addObject:@"Kingthings Organica"];
    [temp addObject:@"Lemon/Milk"];
    [temp addObject:@"Linux Libertine Slanted"];
    [temp addObject:@"Lissain Didone"];
    [temp addObject:@"Martell-Bold"];
    [temp addObject:@"Poetsen One"];
    [temp addObject:@"Reckoner"];
    [temp addObject:@"Rounded Elegance"];
    [temp addObject:@"Royal Serif"];
    [temp addObject:@"Stentiga-Regular"];
    [temp addObject:@"Subway-Black"];
    [temp addObject:@"Typo GeoSlab Regular Demo"];
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

+(NSArray<UIFont*>*)bodyFontsWithSize:(CGFloat)size
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSArray<NSString*>* names=[self bodyFontPostScriptNames];
    [temp addObject:[UIFont systemFontOfSize:size]];
    for(NSInteger i=1; i<names.count; i++)
    {
        NSLog(@"i=%ld",(long)i);
        [temp addObject:[UIFont fontWithName:names[i] size:size]];
    }
    return [NSArray arrayWithArray:temp];
}

@end
