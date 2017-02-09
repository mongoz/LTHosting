//
//  popupToolView.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "toolKitViewController.h"
#import "popupToolResponder.h"

typedef enum sliderPopUpType{
    LTpopupBorderWidthTool,
    LTpopupCornerRadiusTool,
    LTpopupBorderColorTool,
    LTpopupBodyFontTool,
    LTpopupTitleFontTool,
    LTpopupBodyTextAlignmentTool,
    LTpopupTitleTextAlignmentTool,
    LTpopupBorderShadeTool,
    LTpopupBodyTextColorTool,
    LTpopupTitleTextColorTool,
    LTpopupTitleShadeTool,
    LTpopupBodyShadeTool,
    LTpopupBodyTextSizeTool,
    LTpopupTitleTextSizeTool
} popupType;

@interface popupToolView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) id<popupToolResponder> responder;

@property (strong, nonatomic) toolKitViewController *controller;

@property (readwrite) popupType type;

-(void)popIntoView;

-(void)popOutOfView;

-(void)configureWithToolType:(popupType)type;

@property UISlider *slider;

@end



