//
//  textToolViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textToolViewController.h"
#import "colorPopupToolView.h"

@interface textToolViewController (){
    textToolViewControllerType myType;
}

@end

@implementation textToolViewController

-(textToolViewControllerType)type
{
    return myType;
}

-(id)initWithType:(textToolViewControllerType)type
{
    self=[super init];
    myType=type;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generateTools
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Font"];
    [temp addObject:@"Alignment"];
    [temp addObject:@"Color"];
    [temp addObject:@"Shade"];
    [temp addObject:@"Size"];
    self.tools=temp;
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
