//
//  eventViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventOptionVIew.h"

@interface eventViewController : UIViewController <UIDynamicAnimatorDelegate, UIScrollViewDelegate, eventOptionViewDelegate>

@property (strong, nonatomic) IBOutlet UIStackView *stackView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)pressedGo;

@end
