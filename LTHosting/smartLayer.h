//
//  smartLayer.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "popupToolResponder.h"

@protocol smartLayerMirror;

@interface smartLayer : CALayer <CALayerDelegate, popupToolResponder>

@property(readwrite, nonatomic) CGPoint centerPoint;

-(void)moveToCenterPoint:(CGPoint)center;

-(void)moveBy:(CGSize)distance;

-(void)moveBy:(CGSize)distance interval:(NSTimeInterval)interval;

@property (readwrite, nonatomic) NSInteger stackIndex;

@property (strong, nonatomic) id<smartLayerMirror> mirror;

@property CGRect parentRect;

-(void)setMirror:(id<smartLayerMirror>)mirror;

-(void)scaleBy:(CGFloat)scale;

-(void)setFrame:(CGRect)frame animated:(BOOL)animated;

-(void)setColor:(CGColorRef)color;

-(CGColorRef)color;

-(float)colorValue;

-(void)setColorValue:(float)val;

@end


//Protocol to help update thumbnails when layers are changed
@protocol smartLayerMirror <NSObject>

@required
-(void)layerDidChange:(smartLayer*)layer;

-(void)layerWasCreated:(smartLayer*)layer;

-(void)layerWasDeleted:(smartLayer*)layer;

@optional
-(void)layerWasSelected;

-(void)layerWasDeselected;
@end
