//
//  hubMainViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"

@interface hubMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *flyerView;

@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) IBOutlet UIView *controlView;

@property (strong, nonatomic) event *thisEvent;

@end
