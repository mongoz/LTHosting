//
//  eventViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventViewController.h"
#import "addressOptionView.h"
#import "aboutOptionView.h"
#import "datePickerOptionView.h"
#import "pickerOptionView.h"
#import "switchOptionView.h"
#import "goOptionView.h"

@interface eventViewController (){
    
    UIDynamicAnimator *animator;
    
    NSMutableArray<eventOptionView*>* allViews;
    
    CGRect keyboardFrame;
}
@end

@implementation eventViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.delegate=self;
    [self registerForKeyboardNotifications];
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    [_stackView setDistribution:UIStackViewDistributionFill];
    [_stackView setAlignment:UIStackViewAlignmentLastBaseline];
    allViews=[[NSMutableArray alloc] init];
    animator=[[UIDynamicAnimator alloc] init];
    animator.delegate=self;
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(testPressed:)]];
    
    [self configureView];
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    keyboardFrame=keyboardFrameBeginRect;
    [_scrollView setFrame:CGRectMake(0, 0, _scrollView.frame.size.width, self.view.bounds.size.height-keyboardFrame.size.height-self.inputAccessoryView.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    [_scrollView setFrame:self.view.bounds];
}

-(void)configureView
{
    CGFloat barHeight=_scrollView.frame.size.height/9;
    NSMutableArray *views=[[NSMutableArray alloc] init];
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/3);
    [views addObject:[[nameOptionView alloc] initWithFrame:rect barHeight:barHeight]];
    [views addObject:[[addressOptionView alloc] initWithFrame:rect barHeight:barHeight]];
    [views addObject:[[aboutOptionView alloc] initWithFrame:rect barHeight:barHeight]];
    [views addObject:[[datePickerOptionView alloc] initWithFrame:rect barHeight:barHeight]];
    [views addObject:[[switchOptionView alloc] initWithFrame:rect type:LTswitchOptionPrivate barHeight:barHeight]];
    [views addObject:[[switchOptionView alloc] initWithFrame:rect type:LTswitchOptionFree barHeight:barHeight]];
    [views addObject:[[pickerOptionView alloc] initWithFrame:rect type:LTPickerOptionMusic barHeight:barHeight]];
    [views addObject:[[pickerOptionView alloc] initWithFrame:rect type:LTPickerOptionVenue barHeight:barHeight]];
    [views addObject:[[goOptionView alloc] initWithFrame:rect barHeight:barHeight]];
    allViews=views;
    
    for(NSInteger i=allViews.count-1; i>=0; i--)
    {
        [_stackView insertArrangedSubview:allViews[i] atIndex:0];
        allViews[i].myDelegate=self;
    }
}

-(void)accessoryShowingDidChangeForEventOptionView:(eventOptionView *)view
{
    [self recalculateContentSize];
}

-(void)accessoryShowingWillChangeForEventOptionView:(eventOptionView *)view
{
    for(NSInteger i=1; i<allViews.count; i++)
    {
        if(allViews[i]==view)
        {
            NSInteger savei=i;
            while(i>0)
            {
                i--;
                if([allViews[i] isAccessoryViewShowing])
                {
                    [allViews[i] tapBar];
                }
            }
            i=savei;
            while(i<allViews.count-1)
            {
                i++;
                if([allViews[i] isAccessoryViewShowing])
                {
                    [allViews[i] tapBar];
                }
                
            }
            break;
        }
    }
    
}


-(void)recalculateContentSize
{
    CGFloat totalHeight=0;
    for(eventOptionView *v in allViews)
    {
        totalHeight+=v.barView.frame.size.height;
        if([v isAccessoryViewShowing])
        {
            totalHeight+=v.accessoryView.frame.size.height;
        }
    }
    [UIView animateWithDuration:.25 animations:^{
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, totalHeight)];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width, 1000)];
    [_stackView setFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.contentSize.height)];
    [self recalculateContentSize];
}

-(IBAction)testPressed:(id)sender
{
    [self hideAll];
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

-(void)hideAll
{
    for(eventOptionView *v in allViews)
    {
        if([v isAccessoryViewShowing])
        {
            [v tapBar];
        }
    }
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animato
{
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}

NSDate *lastUpdate=nil;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(lastUpdate==nil)
    {
        lastUpdate=[NSDate date];
        return;
    }
    if([[NSDate date] timeIntervalSinceDate:lastUpdate]>.1)
    {
        lastUpdate=[NSDate date];
        CGFloat miny=0;
        for(UIView *v in _stackView.arrangedSubviews)
        {
            CGFloat newY=CGRectGetMinY(v.frame);
            if(newY>miny)
            {
                miny=newY;
            }
        }
    }
}

-(void)pressedGo
{
    [self performSegueWithIdentifier:@"toCamera" sender:self];
}

-(void)goWasPressed
{
    for(eventOptionView *v in allViews)
    {
        [v detailEditingWillEnd];
    }
    [self pressedGo];
}

@end
