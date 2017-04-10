//
//  LTTextViewImageContainer.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTTextViewImageContainer;

@protocol LTTextViewImageContainerDelegate <NSObject>

-(void)removeImageContainer:(LTTextViewImageContainer*)container;

@end

@interface LTTextViewImageContainer : UIView

@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) id<LTTextViewImageContainerDelegate> delegate;

@end
