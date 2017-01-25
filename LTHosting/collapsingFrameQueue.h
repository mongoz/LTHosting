//
//  collapsingFrameQueue.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface collapsingFrameQueue : NSObject

@property (strong, nonatomic) CALayer *destinationLayer;

-(void)addOriginChange:(CGSize)change;

-(void)addScaleBy:(CGFloat)scale;

-(id)initWithDestinationLayer:(CALayer*)destLayer;

@end
