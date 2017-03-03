//
//  ViewController.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textEditingLayer.h"
#import "textEditor.h"

@interface flyerViewController : UIViewController <textEditorDelegate>

@property BOOL toolsShowing;

-(void)setToolsShowing:(BOOL)toolsShowing animated:(BOOL)animated;

-(void)beginTextEditingWithLayer:(textEditingLayer*)layer;

@end

