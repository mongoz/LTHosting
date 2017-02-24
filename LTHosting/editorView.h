//
//  editorView.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textEditingLayer;
@class borderEditingLayer;

@interface editorView : UIView

+(id)shared;

-(void)reset;

//Setters

-(void)setImage:(UIImage*)image;

-(void)setBorder:(UIImage*)bimage;

//Getters

-(textEditingLayer*)titleLayer;

-(textEditingLayer*)bodyLayer;

-(borderEditingLayer*)borderLayer;

@end
