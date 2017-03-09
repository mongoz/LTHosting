//
//  selectionViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "selectionViewController.h"

@interface selectionViewController ()

@end

@implementation selectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_hostingButton addTarget:self action:@selector(transitionToHosting:) forControlEvents:UIControlEventTouchUpInside];
    [_eventPageButton addTarget:self action:@selector(transitionToEventPage:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)transitionToHosting:(UIButton*)button
{
    [self performSegueWithIdentifier:@"toHosting" sender:self];
}

-(void)transitionToEventPage:(UIButton*)butto
{
    UIViewController *dest=[[UIStoryboard storyboardWithName:@"EventPage" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"eventPage"];
    [self.navigationController pushViewController:dest animated:YES];
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

@end
