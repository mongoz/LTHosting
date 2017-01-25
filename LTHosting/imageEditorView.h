//
//  imageEditorView.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"
#import "smartBorderLayer.h"
#import "smartTextLayer.h"
#import "smartLayerThumbnail.h"

@protocol imageEditorViewDelegate <NSObject>

@end

@interface imageEditorView : UIView <UIGestureRecognizerDelegate, UITextViewDelegate>

@property (strong, nonatomic) id<imageEditorViewDelegate> delegate;

+(imageEditorView*)sharedInstance;

-(CGSize)size;

-(void)addBorderLayerWithThumbnail:(smartLayerThumbnail*)nail;

-(void)addTextLayerWithThumbnail:(smartLayerThumbnail*)nail;

-(void)updateImageContainer;

-(void)createNewLayerWithController:(UIViewController*)controller thumbnail:(smartLayerThumbnail*)nail;

-(void)setSelectedLayer:(smartLayer*)layer;

-(smartLayer*)selectedLayer;

-(void)reset;

-(void)removeSelectedLayer;

-(UIImage*)currentImage;

@end


