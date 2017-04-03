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
#import "cblock.h"
#import "usefulArray.h"

@interface eventViewController (){
    
    UIDynamicAnimator *animator;
    
    NSMutableArray<eventOptionView*>* allViews;
    
    CGRect keyboardFrame;
    
    eventOptionView *selectedView;
}
@end

@implementation eventViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[cblock make:^id{
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chevron Left-50"] style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
        CGFloat cushion=8.0f;
        CGFloat right=24.0f;
        [item setImageInsets:UIEdgeInsetsMake(cushion, cushion-right, cushion, cushion+right)];
        return item;
    }]];
    [self.navigationItem setTitleView:[cblock make:^id{
        UILabel *lab=[[UILabel alloc] init];
        [lab setAttributedText:[[NSAttributedString alloc] initWithString:@"H O S T" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[usefulArray bodyFontsWithSize:36.0f][6]}]];
        [lab sizeToFit];
        return lab;
    }]];
    selectedView=nil;
    _scrollView.delegate=self;
    _scrollView.bounces=NO;
    _scrollView.delaysContentTouches=NO;
    [self registerForKeyboardNotifications];
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    [_stackView setDistribution:UIStackViewDistributionFill];
    [_stackView setAlignment:UIStackViewAlignmentLastBaseline];
    allViews=[[NSMutableArray alloc] init];
    animator=[[UIDynamicAnimator alloc] init];
    animator.delegate=self;
    // Do any additional setup after loading the view.
    [self configureView];
}
                                               
-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    CGFloat goHeight=self.view.frame.size.height/6.0f;
    CGFloat barHeight=(_scrollView.frame.size.height-goHeight)/8;
    NSMutableArray *views=[[NSMutableArray alloc] init];
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width, barHeight+_scrollView.frame.size.height/3.0f);
    void (^addOptionType)(NSString *name, NSString *imageName)=^(NSString *name, NSString *imageName){
        [views addObject:[cblock make:^id{
            eventOptionView *ob=[[NSClassFromString(name) alloc] initWithFrame:rect barHeight:barHeight];
            if(imageName!=nil&&imageName.length>0){
                ob.optionImage=[UIImage imageNamed:imageName];
            }
            return ob;
        }]];
    };
    addOptionType(@"nameOptionView",@"event name");
    addOptionType(@"addressOptionView",@"location");
    addOptionType(@"aboutOptionView",@"about section");
    addOptionType(@"datePickerOptionView",@"Calendar-50");
    [views addObject:[[switchOptionView alloc] initWithFrame:rect type:LTswitchOptionPrivate barHeight:barHeight]];
    [views addObject:[[switchOptionView alloc] initWithFrame:rect type:LTswitchOptionFree barHeight:barHeight]];
    [views addObject:[[pickerOptionView alloc] initWithFrame:rect type:LTPickerOptionMusic barHeight:barHeight]];
    [views addObject:[[pickerOptionView alloc] initWithFrame:rect type:LTPickerOptionVenue barHeight:barHeight]];
    [views addObject:[[goOptionView alloc] initWithFrame:rect barHeight:goHeight]];
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
    if(view.isAccessoryViewShowing){
        CGRect viewFrame=[view convertRect:view.bounds toView:_scrollView];
        [_scrollView scrollRectToVisible:viewFrame animated:YES];
    }
    
}

-(void)accessoryShowingWillChangeForEventOptionView:(eventOptionView *)view
{
    [self invalidateSelectedView];
    BOOL oneOpen=NO;
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
                    oneOpen=YES;
                }
            }
            i=savei;
            while(i<allViews.count-1)
            {
                i++;
                if([allViews[i] isAccessoryViewShowing])
                {
                    [allViews[i] tapBar];
                    oneOpen=YES;
                }
                
            }
            break;
        }
    }
    if(view.isAccessoryViewShowing){
        [UIView animateWithDuration:.2 animations:^{
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height-view.accessoryView.frame.size.height)];
        }];
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

-(NSArray<NSString*>*)incompleteOptions
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for(eventOptionView *v in allViews)
    {
        if(!v.isComplete)
        {
            [arr addObject:v.optionName];
        }
    }
    return arr;
}

-(void)goWasPressed
{
    NSArray<NSString*>* incompleteArray=[self incompleteOptions];
    if(incompleteArray.count==0)
    {
        for(eventOptionView *v in allViews)
        {
            [v detailEditingWillEnd];
        }
        [self pressedGo];
    }
    else
    {
        NSMutableString *completeString=[[NSMutableString alloc] init];
        [completeString appendString:@"Complete the following fields to continue:"];
        for(NSString *op in incompleteArray)
        {
            [completeString appendString:[NSString stringWithFormat:@"\n-%@",op]];
        }
        if(self.selectedOption!=nil){
            [self.selectedOption tapBar];
        }
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Incomplete Event" message:completeString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSMutableArray *ops=[[NSMutableArray alloc] init];
            for(NSString *op in incompleteArray){
                [ops addObject:[self viewForOptionName:op]];
            }
            [self flashOptionsRed:ops completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

-(eventOptionView*)viewForOptionName:(NSString *)optionName{
    for(eventOptionView *v in allViews){
        if([v.optionName isEqualToString:optionName]){
            return v;
        }
    }
    return nil;
}

-(void)flashOptionsRed:(NSArray<eventOptionView*>*)options completion:(void(^)())completionBlock{
    NSMutableDictionary<NSString*,UIColor*> *prevColors=[[NSMutableDictionary alloc] init];
    for(eventOptionView *op in options){
        prevColors[op.optionName]=op.backgroundColor;
    }
    NSTimeInterval time=.2;
    [UIView animateWithDuration:time animations:^{
        for(eventOptionView *v in options){
            v.red=YES;
        }
    }completion:^(BOOL finished){
        while(!finished){
            
        }
        [UIView animateWithDuration:time animations:^{
            for(eventOptionView *v in options){
                v.red=NO;
            }
        }completion:^(BOOL finished){
            if(completionBlock!=nil){
                completionBlock();
            }
        }];
    }];
}

-(eventOptionView*)selectedOption{
    if(selectedView==nil){
        for(eventOptionView *v in allViews){
            if(v.isAccessoryViewShowing){
                selectedView=v;
                break;
            }
        }
    }
    return selectedView;
}

-(void)invalidateSelectedView{
    selectedView=nil;
}

@end
