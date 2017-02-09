//
//  eventsNavigationController.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/4/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventsNavigationController : UINavigationController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

-(UIScrollView*)scrollView;

@end
