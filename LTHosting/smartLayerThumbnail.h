//
//  smartLayerThumbnail.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "smartTextLayer.h"

@protocol smartLayerThumbnailManager;

@interface smartLayerThumbnail : UIView <smartLayerMirror>

-(BOOL)isSelected;

@property (strong, nonatomic) id<smartLayerThumbnailManager> manager;

@property CGRect trashFrame;

-(smartLayer*)sourceLayer;

@end

@protocol smartLayerThumbnailManager <NSObject>

@required
-(void)layerWasPoppedForThumbnail:(smartLayerThumbnail*)nail;

-(void)thumbnailCenterDidEnterTrashFrame:(smartLayerThumbnail*)nail;

@optional
-(void)layerWasSelected:(smartLayerThumbnail*)nail;

-(void)layerWasDeselected:(smartLayerThumbnail*)nail;

@end
