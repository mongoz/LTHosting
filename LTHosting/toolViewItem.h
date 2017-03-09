//
//  toolViewItem.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toolView.h"

@class editingLayer;
@class tool;
@protocol buttonTouchDelegate;

typedef enum types{
    borderPickerTool,
    colorPickerTool,
    shadePickerTool,
    sizePickerTool,
    fontPickerTool,
    alignmentTool,
    tintTool
}toolSkew;

@interface toolViewItem : UIButton

@property (strong, nonatomic) NSAttributedString *labelText;

@property (strong, nonatomic) UIImage *image;

-(id)initWithSkew:(toolSkew)skew target:(editingLayer*)target toolType:(toolType)type;

-(tool*)correspondingTool;

-(void)setButtonDelegate:(id<buttonTouchDelegate>)del;

@property BOOL selectable;

@property (nonatomic) UIFont *labelFont;

@end
