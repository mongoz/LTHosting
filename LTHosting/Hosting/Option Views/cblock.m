//
//  cblock.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/30/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "cblock.h"

@implementation cblock

+(id)make:(id (^)())creationBlock{
    return creationBlock();
}


@end
