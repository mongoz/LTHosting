//
//  imageInspectionView.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/30/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class imageInspectionView;

@protocol imageInspectionViewDelegate<NSObject>

-(void)inspectionViewDidDismiss:(imageInspectionView*)view;

@end

@interface imageInspectionView : UIView<UIScrollViewDelegate>

@property (nonatomic) UIImageView *imageView;

@property (weak, nonatomic) id<imageInspectionViewDelegate> delegate;

@end
