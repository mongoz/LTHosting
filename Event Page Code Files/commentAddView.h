//
//  commentAddView.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/8/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@class commentsHeaderView;
@class commentAddContainer;

@interface commentAddView : UIView

-(void)beginEditingWithCompletion:(void(^)())completionBlock;

-(void)endEditingWithCompletion:(void(^)())completionBlock;

-(id)initWithUser:(user*)someUser;

-(id)initWithFrame:(CGRect)frame user:(user*)someUser;

@property (strong, nonatomic) user *poster;

@property (weak, nonatomic) commentsHeaderView *home;

@property (weak, nonatomic) commentAddContainer *container;

@end
