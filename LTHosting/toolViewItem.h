//
//  toolViewItem.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class editingLayer;
@class tool;
@class toolView;
@protocol buttonTouchDelegate;

typedef enum types{
    borderPickerTool,
    colorPickerTool,
    shadePickerTool,
    sizePickerTool,
    fontPickerTool,
    alignmentTool
}toolSkew;

@interface toolViewItem : UIButton

@property (strong, nonatomic) NSAttributedString *labelText;

@property (strong, nonatomic) UIImage *image;

-(id)initWithSkew:(toolSkew)skew target:(editingLayer*)target;

-(tool*)correspondingTool;

-(void)setButtonDelegate:(id<buttonTouchDelegate>)del;

@property BOOL selectable;

@property (nonatomic) UIFont *labelFont;

@end
