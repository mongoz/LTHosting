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

+(NSArray<NSString*>*)titleFontPostScriptNames{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Bebas Neue"];
    [temp addObject:@"Allstar-Regular"];
    [temp addObject:@"BluePrinted"];
    [temp addObject:@"CloisterBlack-Light"];
    [temp addObject:@"CurlyShirley"];
    [temp addObject:@"DoubleBubbleShadow"];
    [temp addObject:@"DS-Digital"];
    [temp addObject:@"Easy3D"];
    //[temp addObject:@"jibriiRegular"];
    [temp addObject:@"JohnnyTorchRotalic"];
    [temp addObject:@"KGDarkSide"];
    [temp addObject:@"KGTrueColors"];
    [temp addObject:@"MarketDeco"];
    [temp addObject:@"NeonLights-"];
    [temp addObject:@"Originalbyfnkfrsh"];
    [temp addObject:@"ParkLaneNF"];
    //[temp addObject:@"PrettyGirlsScriptDemo"];
    //[temp addObject:@"RoyalAcidBath"];
    [temp addObject:@"SketchHandwriting"];
    //[temp addObject:@"Stranger-back-in-the-Night"];
    [temp addObject:@"TradizionalDEMO-Regular"];
    return [NSArray arrayWithArray:temp];
}

+(NSArray<UIImage*>*)borderImages
{
    static NSArray *ret=nil;
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:[self imageWithContentsOfFileWithName:@"aceofspade"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"altered"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"arrows"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"arrows2"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"diamonds"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"hearts"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"leaves"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"paws"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"pointer"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"rounded square"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"skulls"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"stars"]];
    [temp addObject:[self imageWithContentsOfFileWithName:@"triangles"]];
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
        [temp addObject:@"Ace of Spades"];
        [temp addObject:@"Altered"];
        [temp addObject:@"Arrows"];
        [temp addObject:@"Arrows2"];
        [temp addObject:@"Diamonds"];
        [temp addObject:@"Hearts"];
        [temp addObject:@"Leaves"];
        [temp addObject:@"Paws"];
        [temp addObject:@"Pointer"];
        [temp addObject:@"Rounded Square"];
        [temp addObject:@"Skulls"];
        [temp addObject:@"Stars"];
        [temp addObject:@"Triangles"];
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

+(NSArray<UIFont*>*)bodyFontsWithSize:(CGFloat)size{
    return [self  fontsWithNames:[self bodyFontPostScriptNames] size:size];
}

+(NSArray<UIFont*>*)titleFontsWithSize:(CGFloat)size{
    return [self fontsWithNames:[self titleFontPostScriptNames] size:size];
}

+(NSArray<UIFont*>*)fontsWithNames:(NSArray<NSString*>*)names size:(CGFloat)size{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    for(NSInteger i=0; i<names.count; i++)
    {
        [temp addObject:[UIFont fontWithName:names[i] size:size]];
    }
    return [NSArray arrayWithArray:temp];
}

@end
