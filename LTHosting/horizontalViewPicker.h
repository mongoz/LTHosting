//
//  horizontalViewPicker.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol horizontalViewPickerDataSource;

@protocol horizontalViewPickerDelegate;

////////////////////////////////////////////////////////////////////////////

@interface horizontalViewPicker : UIScrollView <UIGestureRecognizerDelegate>

@property (readonly) CGFloat margin;

@property (strong, nonatomic) id<horizontalViewPickerDataSource> dataSource;

@property (strong, nonatomic) id<horizontalViewPickerDelegate> hDelegate;

-(void)reloadData;

@end

@protocol horizontalViewPickerDataSource <NSObject>

@required
//If a view is not of the proper size, it will be resized to fit inside thumbnail
-(UIView*)viewForIndex:(NSInteger)index;

-(NSInteger)numberOfViews;

@end

@protocol horizontalViewPickerDelegate <UIScrollViewDelegate>

@required

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index;

@end
