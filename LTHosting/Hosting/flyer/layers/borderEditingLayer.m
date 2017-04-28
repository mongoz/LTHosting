//
//  borderEditingLayer.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "borderEditingLayer.h"

@implementation borderEditingLayer

CALayer *maskLayer=nil;

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:maskLayer forKey:@"maskLayer"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    maskLayer=[aDecoder decodeObjectForKey:@"maskLayer"];
    self.mask=maskLayer;
    return self;
}

-(void)setColor:(UIColor *)color
{
    if(maskLayer==nil)
    {
        maskLayer=[CALayer layer];
        maskLayer.frame=self.bounds;
        maskLayer.contents=self.contents;
        self.contents=nil;
        self.mask=maskLayer;
    }
    else if(color==[UIColor clearColor])
    {
        self.contents=maskLayer.contents;
        self.mask=nil;
        maskLayer=nil;
    }
    [self setBackgroundColor:color.CGColor];
}

-(void)setMask:(CALayer *)mask
{
    if(mask==nil)
    {
        maskLayer=nil;
    }
    [super setMask:mask];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(self.mask!=nil)
    {
        [self.mask setFrame:self.bounds];
    }
}

@end
