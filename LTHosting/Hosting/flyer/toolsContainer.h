//
//  toolsContainer.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@class toolView;

@protocol toolViewSuper <NSObject>

-(void)toolView:(toolView*)view isEditingWillChangeTo:(BOOL)isEditing;

-(void)viewWillAppear:(BOOL)animated;

-(void)viewWillDisappear:(BOOL)animated;

@end

@interface toolsContainer : UIView <toolViewSuper>

@end
