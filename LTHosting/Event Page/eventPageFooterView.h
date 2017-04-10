//
//  eventPageFooterView.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eventPageFooterView;

@protocol eventPageFooterViewDelegate <NSObject>

-(void)didPressAccept:(eventPageFooterView*)view;

-(void)didPressDeny:(eventPageFooterView*)view;

@end

@interface eventPageFooterView : UIView

@property (weak, nonatomic) id<eventPageFooterViewDelegate> delegate;

-(id)initWithWidth:(CGFloat)width;

+(eventPageFooterView*)footerViewWithWidth:(CGFloat)width;

@end
