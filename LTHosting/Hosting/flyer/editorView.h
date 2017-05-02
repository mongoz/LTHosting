//
//  editorView.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textEditingLayer.h"
#import "borderEditingLayer.h"
#import "flyerViewController.h"
#import "tintEditinglayer.h"

@class textEditingLayer;
@class borderEditingLayer;

@interface editorView : UIView<editingLayoutManager>

+(id)shared;

+(void)setSharedInstance:(editorView*)existing;

-(void)reset;

//Setters

-(void)setImage:(UIImage*)image;

-(void)setBorder:(UIImage*)bimage;

-(void)setBorderIndex:(NSInteger)borderIndex;

@property (readonly) NSInteger borderIndex;

-(void)setTitleText:(NSString*)title;

-(void)setBodyText:(NSString*)body;

//Getters

-(textEditingLayer*)titleLayer;

-(textEditingLayer*)bodyLayer;

-(borderEditingLayer*)borderLayer;

-(tintEditinglayer*)backgroundTintLayer;

@property (nonatomic) BOOL isEditing;

@property (weak, nonatomic) flyerViewController *viewController;

@property (readonly) UIImage *currentImage;

@end
