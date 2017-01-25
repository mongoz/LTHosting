//
//  toolKitViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageEditorView.h"


@class imageEditorView;

@protocol  toolKitSuperController;

@interface toolKitViewController : UIViewController<smartLayerThumbnailManager, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UISegmentedControl *toolBar;

@property NSArray *tools;

-(BOOL)isUsingTool;

-(void)setIsUsingTool:(BOOL)isIt;

@property (strong, nonatomic) id<toolKitSuperController> superController;

//Subclasses should define the following method to create an array of objects to use as buttons on the uisegmentedcontrol
-(void)generateTools;

@end

@protocol toolKitSuperController <NSObject>

@optional

-(void)toolKitDidBeginUsingTool;

-(void)toolKitDidEndUsingTool;

@end
