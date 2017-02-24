//
//  editingLayer.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "editingLayer.h"

@implementation editingLayer

-(id)init
{
    self=[super init];
    self.backgroundColor=[UIColor clearColor].CGColor;
    return self;
}

-(void)setColor:(UIColor*)color{}

-(UIColor*)color
{
    return [UIColor colorWithCGColor:self.backgroundColor];
}

@end
