//
//  tool.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toolViewItem.h"
#import "editingLayer.h"

@protocol toolDelegate;

@interface tool : UIView

@property (weak, nonatomic) id<toolDelegate> toolDelegate;

-(id)initWithTarget:(editingLayer*)target skew:(toolSkew)skew;

-(id)initWithFrame:(CGRect)frame target:(editingLayer*)target skew:(toolSkew)skew;

-(void)dissolveIn:(BOOL)in completion:(void(^)())completionBlock;

@property (weak, nonatomic) editingLayer *targetLayer;

-(void)updateCurrentValueAnimated:(BOOL)animated;

-(void)toolDidLoad;

-(void)toolWillAppear;

@end
