//
//  ViewController.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerViewController.h"
#import "editorView.h"
#import "toolView.h"
#import "event.h"

@interface flyerViewController (){
    UIButton *modeButton;
    
    toolsContainer *toolViewer;
    
    BOOL toolsShowing;
}
@end

@implementation flyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:[editorView shared]];
    
    [[editorView shared] setFrame:self.view.bounds];
    toolViewer=nil;
    toolsShowing=NO;
    
    CGFloat margin=8;
    CGFloat width=64;
    modeButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-margin-width, [[editorView shared] frame].origin.y+margin, width, width)];
    [modeButton addTarget:self action:@selector(modeButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [modeButton addTarget:self action:@selector(modeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [modeButton addTarget:self action:@selector(modeButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [modeButton.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [modeButton.layer setCornerRadius:modeButton.frame.size.height/2];
    [modeButton.layer setMasksToBounds:YES];
    [self.view addSubview:modeButton];
    
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backbutton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[editorView shared] setImage:[[event sharedInstance] image]];
    [[editorView shared] setFrame:self.view.bounds];
    
}

-(IBAction)backPressed:(UIBarButtonItem*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Managing tool view

-(void)toggleToolViewAnimated:(BOOL)animated completion:(void(^)())completionBlock
{
    if(!toolsShowing)
    {
        [self showToolViewAnimated:animated completiong:completionBlock];
    }
    else
    {
        [self hideToolViewAnimated:animated completion:completionBlock];
    }
}

BOOL set=NO;

-(void)showToolViewAnimated:(BOOL)animated completiong:(void(^)())completionBlock
{
    if(toolViewer==nil)
    {
        toolViewer=[[toolsContainer alloc] init];
        [toolViewer setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height/3)];
        [toolViewer setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.view addSubview:toolViewer];
        set=YES;
    }
    CGRect editorDestFrame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-toolViewer.frame.size.height);
    CGRect toolDestFrame=CGRectMake(toolViewer.frame.origin.x, toolViewer.frame.origin.y-toolViewer.frame.size.height, toolViewer.frame.size.width, toolViewer.frame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [toolViewer setFrame:toolDestFrame];
        [[editorView shared] setFrame:editorDestFrame];
    } completion:^(BOOL finished){
        
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
    toolsShowing=YES;
}

-(void)hideToolViewAnimated:(BOOL)animated completion:(void(^)())completionBlock
{
    if(toolViewer==nil)
    {
        return;
    }
    CGRect editorDestFrame=self.view.bounds;
    CGRect toolDestFrame=CGRectMake(toolViewer.frame.origin.x, toolViewer.frame.origin.y+toolViewer.frame.size.height, toolViewer.frame.size.width, toolViewer.frame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [[editorView shared] setFrame:editorDestFrame];
        [toolViewer setFrame:toolDestFrame];
    } completion:^(BOOL finished){
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
    toolsShowing=NO;
}

//Managing mode button

-(IBAction)modeButtonTouchDown:(UIButton*)mButton
{
    [self animateButton:mButton touchDown:YES completion:nil];
}

-(IBAction)modeButtonTouchUpInside:(UIButton*)mButton
{
    if(modeButton.layer.backgroundColor==[UIColor blackColor].CGColor)
    {
        modeButton.layer.backgroundColor=[UIColor redColor].CGColor;
    }
    else
    {
        modeButton.layer.backgroundColor=[UIColor blackColor].CGColor;
    }
    [self modeTouchedUp];
    [self toggleToolViewAnimated:YES completion:nil];
}

-(IBAction)modeButtonTouchUpOutside:(UIButton*)mButton
{
    [self modeTouchedUp];
}

-(void)modeTouchedUp
{
    [self animateButton:modeButton touchDown:NO completion:nil];
}

//Method to animate button touches up & down
-(void)animateButton:(UIButton*)button touchDown:(BOOL)down completion:(void(^)())completionBlock
{
    CGFloat sizeConstant=1.05f;
    if(down)
    {
        sizeConstant=1/sizeConstant;
    }
    CGRect endFrame=CGRectMake(button.frame.origin.x+(button.frame.size.width*(1-sizeConstant)), button.frame.origin.y+(button.frame.size.width*(1-sizeConstant)), button.frame.size.width*sizeConstant, button.frame.size.height*sizeConstant);
    
    [UIView animateWithDuration:.15 animations:^{
        [button setFrame:endFrame];
        [button.layer setCornerRadius:button.layer.cornerRadius*sizeConstant];
    } completion:^(BOOL finished){
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}


@end
