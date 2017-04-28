//
//  hubInvitesViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hostingHubPageController.h"

@interface hubInvitesViewController : UIViewController<hubVC>

@property (weak, nonatomic) hostingHubPageController *pageViewController;

@end
