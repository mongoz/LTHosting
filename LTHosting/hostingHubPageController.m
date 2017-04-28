//
//  hostingHubViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "hostingHubPageController.h"
#import "cblock.h"

@interface hostingHubPageController (){
    NSArray<UIViewController<hubVC>*>* pages;
    NSInteger currentPage;
    
    UILabel *titleLabel;
    UIView *leftButton;
    UIView *rightButton;
}

@end

@implementation hostingHubPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    for(UIView *v in self.view.subviews){
        if([v.class isSubclassOfClass:[UIScrollView class]]){
            [(UIScrollView*)v setScrollEnabled:NO];
        }
    }
    [event setSharedInstance:self.event];
    
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    UIStoryboard *thisBoard=[UIStoryboard storyboardWithName:@"HostingHub" bundle:[NSBundle mainBundle]];
    UIViewController* (^getWithName)(NSString*)=^UIViewController*(NSString *string){
        UIViewController *vc=[thisBoard instantiateViewControllerWithIdentifier:string];
        [(UIViewController<hubVC>*)vc setPageViewController:self];
        return vc;
    };
    [temp addObject:getWithName(@"hubRequests")];
    [temp addObject:getWithName(@"hubMain")];
    [temp addObject:getWithName(@"hubInvites")];
    pages=temp;
    currentPage=-1;
    self.delegate=self;
    [self setPage:1 animated:NO];
    // Do any additional setup after loading the view.
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    leftButton=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    rightButton=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setLeftBarButtonItem:left];
    [self.navigationItem setRightBarButtonItem:right];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/*-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
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
}*/

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

-(void)willTransitionToViewController:(UIViewController<hubVC>*)vc{
    [UIView animateWithDuration:.15 animations:^{
        titleLabel.alpha=0;
        leftButton.alpha=0;
        rightButton.alpha=0;
    } completion:^(BOOL finished){
        void (^removeSubviews)(UIView*)=^(UIView *v){
            while(v.subviews.count>0){
                [v.subviews.firstObject removeFromSuperview];
            }
        };
        removeSubviews(leftButton);
        removeSubviews(rightButton);
        [titleLabel setText:vc.navigationItem.title];
        if(vc.leftButton!=nil){
            [leftButton addSubview:vc.leftButton];
            vc.leftButton.center=CGPointMake(vc.leftButton.frame.size.width/2, vc.leftButton.frame.size.height/2);
        }
        if(vc.rightButton){
            [rightButton addSubview:vc.rightButton];
            vc.leftButton.center=CGPointMake(vc.rightButton.frame.size.width/2, vc.rightButton.frame.size.height/2);
        }
        [UIView animateWithDuration:.15 animations:^{
            titleLabel.alpha=1;
            leftButton.alpha=1;
            rightButton.alpha=1;
        }];
    }];
}

-(void)didTransitionToViewController:(UIViewController<hubVC>*)vc{
    
}

-(NSInteger)page{
    return currentPage;
}

-(void)setPage:(NSInteger)page{
    [self setPage:page animated:NO];
}

-(void)setPage:(NSInteger)page animated:(BOOL)animated{
    [self setPage:page animated:animated completion:nil];
}

-(void)setPage:(NSInteger)page animated:(BOOL)animated completion:(void(^)())completionBlock{
    if(page!=currentPage){
        NSInteger old=currentPage;
        currentPage=page;
        UIViewController<hubVC> *vc=pages[currentPage];
        [self willTransitionToViewController:vc];
        __weak typeof(self) weakSelf=self;
        [self setViewControllers:@[vc] direction:currentPage>old?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:animated completion:^(BOOL finished){
            if(completionBlock!=nil){
                completionBlock();
            }
            if(finished){
                [weakSelf didTransitionToViewController:vc];
            }
        }];
    }
    else if(completionBlock!=nil){
        completionBlock();
    }
}

@end
