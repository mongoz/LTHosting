//
//  hostingHubViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "hostingHubViewController.h"
#import "cblock.h"

@interface hostingHubViewController (){
    NSArray<UIViewController*>* pages;
}

@end

@implementation hostingHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    UIStoryboard *thisBoard=[UIStoryboard storyboardWithName:@"HostingHub" bundle:[NSBundle mainBundle]];
    UIViewController* (^getWithName)(NSString*)=^UIViewController*(NSString *string){
        return [thisBoard instantiateViewControllerWithIdentifier:string];
    };
    [temp addObject:getWithName(@"hubRequests")];
    [temp addObject:getWithName(@"hubMain")];
    pages=temp;
    self.dataSource=self;
    [self setViewControllers:@[pages[1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){
        
    }];
    // Do any additional setup after loading the view.
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index=[pages indexOfObject:viewController];
    if(index>0){
        return pages[index-1];
    }
    return nil;
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index=[pages indexOfObject:viewController];
    if(index<pages.count-1){
        return pages[index+1];
    }
    return nil;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return pages.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 1;
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
