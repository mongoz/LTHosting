//
//  toolsView.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "horizontalViewPicker.h"

@protocol buttonTouchDelegate <NSObject>

-(IBAction)buttonTouchedDown:(UIButton*)button;

-(IBAction)buttonTouchedUpInside:(UIButton*)button;

-(IBAction)buttonTouchedUpOutside:(UIButton*)button;

@end

@class tool;
@class toolViewItem;
@class toolsContainer;

typedef enum toolsTypes{
    borderTool,
    bodyTextTool,
    titleTextTool,
    toolTypeNone
}toolType;

@interface toolView : UIView<horizontalViewPickerDelegate, horizontalViewPickerDataSource, buttonTouchDelegate>

@property toolType type;

-(id)initWithType:(toolType)type container:(toolsContainer*)cont;

-(id)initWithFrame:(CGRect)frame type:(toolType)type container:(toolsContainer*)cont;

@property (weak, nonatomic) toolsContainer *container;

-(void)dissolveIn:(BOOL)comingIn completion:(void(^)())completionBlock;

@property (readonly) NSArray<toolViewItem*>* items;

@property toolType myType;
@property (strong, nonatomic) horizontalViewPicker *toolPicker;

-(void)transitionToToolAtIndex:(NSInteger)index completion:(void(^)())completionBlock;

-(void)endUsingTool;

-(void)willAppear;

-(void)willDisappear;

@end

@protocol toolDelegate <NSObject>

@optional

-(void)toolValueChanged:(tool*)tool;
@end
