//
//  editingLayer.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class editingLayer;

@protocol editingLayoutManager <NSObject>

-(void)editingLayer:(editingLayer*)layer frameWillChangeTo:(CGRect)newFrame;

@end

@interface editingLayer : CALayer

-(void)setColor:(UIColor*)color;

-(UIColor*)color;

@property (weak, nonatomic) id<editingLayoutManager> layoutManager;

@end
