//
//  eventsNavigationController.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/4/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "eventsNavigationController.h"
#import "commonUseFunctions.h"
#import "navigationScrollView.h"

@interface eventsNavigationController (){
    navigationScrollView *scroller;
}

@end

@implementation eventsNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    scroller=nil;
    // Do any additional setup after loading the view.
}

-(BOOL)isToolbarHidden
{
    if(self.topViewController==self.viewControllers.firstObject)
    {
        return YES;
    }
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(scroller==nil)
    {
        _navBar=self.navigationBar;
        UIColor *col=self.navigationBar.backgroundColor;
        [self updateBar];
        scroller=[[navigationScrollView alloc] init];
        [scroller setScrollEnabled:YES];
        [scroller setPagingEnabled:YES];
        [scroller setUserInteractionEnabled:YES];
        [scroller setFrame:CGRectMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y+self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationBar.frame.size.height)];
        [scroller setContentSize:CGSizeMake(self.view.frame.size.width, scroller.frame.size.height)];
        UIView *v=self.viewControllers[0].view;
        [v removeFromSuperview];
        [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y-self.navigationBar.frame.origin.y-self.navigationBar.frame.size.height, v.frame.size.width, v.frame.size.height)];
        [scroller addSubview:v];
        scroller.delegate=self;
        [scroller setBackgroundColor:[UIColor whiteColor]];
        [scroller setBounces:NO];
        UIView *me=[self.view copyView];
        [me addSubview:scroller];
        [self setView:me];
        [self.view addSubview:_navBar];
        if(self.inputAccessoryView)
        {
            [self.inputAccessoryView setFrame:CGRectMake(self.inputAccessoryView.frame.origin.x, self.view.frame.size.height, self.inputAccessoryView.frame.size.width, self.inputAccessoryView.frame.size.height)];
            [UIView animateWithDuration:.15 animations:^{
                [self.inputAccessoryView setFrame:CGRectMake(self.inputAccessoryView.frame.origin.x, self.inputAccessoryView.frame.origin.y-self.inputAccessoryView.frame.size.height, self.inputAccessoryView.frame.size.width, self.inputAccessoryView.frame.size.height)];
            }];
            
        }
        [_navBar setBackgroundColor:col];
        [super viewDidAppear:animated];
    }
}

-(UINavigationBar*)navigationBar
{
    if(_navBar==nil)
    {
        return [super navigationBar];
    }
    return _navBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)giveViewBorder:(UIView*)view
{
    [view.layer setBorderColor:[UIColor yellowColor].CGColor];
    [view.layer setBorderWidth:2.0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *newVController=[segue destinationViewController];
    [self presentViewController:newVController animated:YES completion:^{
        NSLog(@"completed");
    }];
}

-(void)pushViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated
{
    [self.topViewController.view setUserInteractionEnabled:NO];
    [scroller setUserInteractionEnabled:NO];
    [super pushViewController:viewControllerToPresent animated:NO];
    UIViewController *v=self.topViewController;
    [v.view removeFromSuperview];
    
    [v.view setFrame:CGRectMake(scroller.contentSize.width, v.view.frame.origin.y, v.view.frame.size.width, self.view.frame.size.height-self.navigationBar.frame.origin.y-self.navigationBar.frame.size.height)];
    [scroller setContentSize:CGSizeMake(scroller.contentSize.width+v.view.frame.size.width, scroller.contentSize.height)];
    
    [scroller addSubview:v.view];
    [v.view.layer setMasksToBounds:YES];
    [v.view layoutIfNeeded];
    [viewControllerToPresent viewWillAppear:YES];
    [UIView animateWithDuration:.25 animations:^{
        [scroller setContentOffset:CGPointMake(scroller.contentOffset.x+scroller.frame.size.width, scroller.contentOffset.y)];
    } completion:^(BOOL finished){
        while(!finished)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
        }
        [scroller setUserInteractionEnabled:YES];
        [viewControllerToPresent viewDidAppear:YES];
        if(self.inputAccessoryView)
        {
            [self becomeFirstResponder];
        }
    }];
}

-(void)popViewController:(UIViewController*)controller animated:(BOOL)animated
{
    [controller viewWillDisappear:YES];
    if(animated)
    {
        [UIView animateWithDuration:.25 animations:^{
            [scroller setContentOffset:CGPointMake(scroller.contentOffset.x-scroller.frame.size.width, scroller.contentOffset.y)];
        } completion:^(BOOL finished){
            [scroller setContentSize:CGSizeMake(scroller.contentSize.width-controller.view.frame.size.width, scroller.contentSize.height)];
            [controller viewDidDisappear:YES];
            [controller.view removeFromSuperview];
            [super popViewControllerAnimated:NO];
            //[controller removeFromParentViewController];
            //[self updateBar];
            [scroller setUserInteractionEnabled:YES];
            [self.topViewController.view setUserInteractionEnabled:YES];
        }];
    }
    else
    {
        [controller viewDidDisappear:YES];
        [scroller setContentSize:CGSizeMake(scroller.contentSize.width-controller.view.frame.size.width, scroller.contentSize.height)];
        [controller.view removeFromSuperview];
        [super popViewControllerAnimated:NO];
        [scroller setUserInteractionEnabled:YES];
        [self.topViewController.view setUserInteractionEnabled:YES];
        
    }
    if(self.inputAccessoryView)
    {
        [self becomeFirstResponder];
    }
}

-(UIScrollView*)scrollView
{
    return scroller;
}

-(UIView*)inputAccessoryView
{
    if(self.topViewController!=self)
    {
        if(self.topViewController.canBecomeFirstResponder)
        {
            return self.topViewController.inputAccessoryView;
        }
    }
    return nil;
}

-(BOOL)canBecomeFirstResponder
{
    if(self.topViewController!=self)
    {
        return self.topViewController.canBecomeFirstResponder;
    }
    return [super canBecomeFirstResponder];
}


-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *popped=self.topViewController;
    [self popViewController:popped animated:animated];
    return popped;
}

-(void)updateBar
{
    [self updateBarWithViewController:self.topViewController];
}

-(void)updateBarWithViewController:(UIViewController*)controller
{
    [_navBar setItems:@[controller.navigationItem]];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIViewController *current=nil;
    for(UIViewController *cont in self.viewControllers)
    {
        if(cont.view.frame.origin.x==scrollView.contentOffset.x)
        {
            current=cont;
            break;
        }
    }
    while(current!=self.topViewController)
    {
        [self popViewController:self.topViewController animated:NO];
    }
}

@end
