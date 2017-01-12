//
//  addressSearchResultsViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/4/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GooglePlaces;
#import "eventDetailViewController.h"

@interface addressSearchResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *searchResultsTableView;

-(void)searchForString:(NSString*)string;

@property (strong) eventDetailViewController *parent;

-(void)setFrame:(CGRect)frame;

@end
