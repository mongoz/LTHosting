//
//  hubInvitesViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "hubInvitesViewController.h"

@interface hubInvitesViewController ()

@end

@implementation hubInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Invite"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIButton*)leftButton{
    UIButton *left=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left setImage:[[UIImage imageNamed:@"Chevron Left-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    left.tintColor=[UIColor whiteColor];
    [left addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat margin=5.0f;
    CGFloat leftOffset=20.0f;
    left.imageEdgeInsets=UIEdgeInsetsMake(margin, margin-leftOffset, margin, margin+leftOffset);
    return left;
}

-(void)backPressed:(id)sender{
    [self.pageViewController setPage:1 animated:YES];
}

-(UIButton*)rightButton{
    return nil;
}

@end
