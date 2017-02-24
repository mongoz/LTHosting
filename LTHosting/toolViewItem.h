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

typedef enum types{
    borderPickerTool,
    colorPickerTool,
    shadePickerTool,
}toolSkew;

@interface toolViewItem : UIButton

@property (strong, nonatomic) NSAttributedString *labelText;

@property (strong, nonatomic) UIImage *image;

-(id)initWithSkew:(toolSkew)skew target:(editingLayer*)target toolView:(toolView*)view;

-(tool*)correspondingTool;

-(void)setButtonDelegate:(id<buttonTouchDelegate>)del;

@property BOOL selectable;

@end
