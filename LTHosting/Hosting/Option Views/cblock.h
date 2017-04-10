//
//  cblock.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/30/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cblock : NSObject

+(id)make:(id(^)())creationBlock;

@end
