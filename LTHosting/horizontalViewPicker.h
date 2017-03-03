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

-(UIColor*)labelTextColor;

-(void)setLabelTextColor:(UIColor*)color;

-(UIFont*)labelFont;

-(CGFloat)heightWidthRatio;

-(void)setHeightWidthRatio:(CGFloat)ratio;

-(void)setLabelFont:(UIFont*)font;

-(void)reloadData;

-(NSInteger)selectedIndex;

-(void)selectRowAtIndex:(NSInteger)index;

@property BOOL showsSelection;

-(void)scrollIndexToVisible:(NSInteger)index animated:(BOOL)animated;

@end

@protocol horizontalViewPickerDataSource <NSObject>

@required
//If a view is not of the proper size, it will be resized to fit inside thumbnail
-(UIView*)viewForIndex:(NSInteger)index;

-(NSInteger)numberOfViews;

-(BOOL)shouldUseLabels;

@optional
-(NSString*)labelForIndex:(NSInteger)index;

@end

@protocol horizontalViewPickerDelegate <UIScrollViewDelegate>

@required

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index;

-(BOOL)shouldHandleViewResizing;

@optional
//Only implement this method if you return 'YES' for shouldHandleViewResizing.  Otherwise, it will never be called.
-(UIView*)view:(UIView*)view inFrame:(CGRect)frame;

@end
