//
//  hubMainViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "event.h"
#import "hostingHubPageController.h"
#import <BBView/BBView.h>

@interface hubMainViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, hubVC>

@property (strong, nonatomic) IBOutlet UIImageView *flyerView;

@property (strong, nonatomic) IBOutlet UICollectionView *controlView;

@property (strong, nonatomic) event *thisEvent;

@property (weak, nonatomic) hostingHubPageController *pageViewController;

@property (strong, nonatomic) IBOutlet BBView *infoView;

@end
