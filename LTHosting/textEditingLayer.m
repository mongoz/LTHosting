//
//  textEditingLayer.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textEditingLayer.h"

@implementation textEditingLayer

-(id)init
{
    self=[super init];
    _textLabel=[[UILabel alloc] init];
    [self addSublayer:_textLabel.layer];
    return self;
}


@end
