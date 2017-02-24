//
//  editingLayer.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface editingLayer : CALayer

-(void)setColor:(UIColor*)color;

-(UIColor*)color;

@end
