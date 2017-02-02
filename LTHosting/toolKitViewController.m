//
//  toolKitViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "toolKitViewController.h"
#import "colorPopupToolView.h"
#import "textToolViewController.h"
#import "fontPopupToolView.h"
#import "textAlignmentPopupToolView.h"

@interface toolKitViewController (){
    CGFloat thumbnailwidth;
    CGFloat thumbnailBorderWidth;
    NSInteger numberOfThumbnails;
    
    NSArray<smartLayerThumbnail*> *activeThumbnails;
    
    CGRect trashFrame;
    
    BOOL isUsingTool;
    
    BOOL hasSelected;
}

    @property (strong, nonatomic) popupToolView *current;

@end

@implementation toolKitViewController

- (void)viewDidLoad {
    [self generateTools];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    numberOfThumbnails=4;
    if(numberOfThumbnails%2!=0)
    {
        NSLog(@"The number of thumbnails provided is not an even number.  This is not allowed.  One thumbnail is being added to the count");
        numberOfThumbnails++;
    }
    thumbnailBorderWidth=8;
    [self calculateThumbnailWidth];
    [self configureView];
    isUsingTool=NO;
    
}

-(void)calculateThumbnailWidth
{
    thumbnailwidth=(self.view.frame.size.width-(numberOfThumbnails+2)*thumbnailBorderWidth)/(numberOfThumbnails+1);
}

-(void)configureView
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    activeThumbnails=[[NSArray alloc] init];
    [self setToolBar];
}

-(void)setPlaceHolders
{
    CGFloat temp=numberOfThumbnails/2.0f;
    CGFloat originHeight=128-thumbnailBorderWidth-thumbnailwidth;
    CGFloat originX=thumbnailBorderWidth;
    for(NSInteger i=0; i<=numberOfThumbnails; i++)
    {
        if((float)i!=temp)
        {
            UIView *newPlaceholder=[self placeHolderView];
            [newPlaceholder setFrame:CGRectMake(originX, originHeight, newPlaceholder.frame.size.width, newPlaceholder.frame.size.height)];
            [self.view addSubview:newPlaceholder];
            
        }
        else
        {
            UIView *trash=[self trashView];
            [trash setFrame:CGRectMake(originX, originHeight, trash.frame.size.width, trash.frame.size.height)];
            trashFrame=trash.frame;
            [self.view addSubview:trash];
        }
        originX+=thumbnailwidth+thumbnailBorderWidth;
    }
}

-(void)setToolBar
{
    _toolBar=[self segmentedControl];
    [_toolBar addTarget:self action:@selector(toolbarTapped:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_toolBar];
}

-(UIView*)placeHolderView
{
    UIView *placeholder=[[UIView alloc] initWithFrame:CGRectMake(0, 0, thumbnailwidth, thumbnailwidth)];
    [placeholder setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *add=[[UILabel alloc] initWithFrame:placeholder.frame];
    [add setText:@"Add"];
    [add setTextAlignment:NSTextAlignmentCenter];
    [placeholder addSubview:add];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeHolderTapped:)];
    [placeholder addGestureRecognizer:tap];
    return placeholder;
}

-(UIView*)trashView
{
    UIImageView *placeholder=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbnailwidth, thumbnailwidth)];
    [placeholder setImage:[UIImage imageNamed:@"maptrash.png"]];
    [placeholder setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trashTapped:)];
    [placeholder addGestureRecognizer:tap];
    return placeholder;
}

-(UISegmentedControl*)segmentedControl
{
    UISegmentedControl *new=[[UISegmentedControl alloc] initWithItems:_tools];
    [new setTintColor:[UIColor whiteColor]];
    [new.layer setBackgroundColor:[UIColor darkTextColor].CGColor];
    [new.layer setMasksToBounds:YES];
    
    CGFloat height=128-thumbnailwidth-3*thumbnailBorderWidth;
    [new setFrame:CGRectMake(thumbnailBorderWidth, thumbnailBorderWidth, self.view.frame.size.width-2*thumbnailBorderWidth, height)];
    return new;
}

-(IBAction)placeHolderTapped:(UITapGestureRecognizer*)tap
{
    if(activeThumbnails.count==0)
    {
        [_toolBar setUserInteractionEnabled:YES];
    }
    UIView *tappedView=tap.view;
    for(smartLayerThumbnail *nail in activeThumbnails)
    {
        if(nail.frame.origin.x==tappedView.frame.origin.x)
        {
            return;
        }
    }
    [self createNewSmartLayerForThumbnailRect:tappedView.frame];
}

-(IBAction)trashTapped:(id)sender
{
    [[imageEditorView sharedInstance] removeSelectedLayer];
}

-(void)createNewSmartLayerForThumbnailRect:(CGRect)trect
{
    smartLayerThumbnail *new=[[smartLayerThumbnail alloc] initWithFrame:trect];
    new.manager=self;
    new.trashFrame=trashFrame;
    [self addActiveThumbnail:new];
    [[imageEditorView sharedInstance] createNewLayerWithController:self thumbnail:new];
}

-(void)addActiveThumbnail:(smartLayerThumbnail*)nail
{
    NSMutableArray *temp=[NSMutableArray arrayWithArray:activeThumbnails];
    [temp addObject:nail];
    activeThumbnails=temp;
    [self.view addSubview:nail];
}

-(void)removeActiveThumbnail:(smartLayerThumbnail*)nail
{
    NSMutableArray *temp=[NSMutableArray arrayWithArray:activeThumbnails];
    [temp removeObject:nail];
    activeThumbnails=temp;
    nail.manager=nil;
    [nail removeFromSuperview];
}

-(IBAction)toolbarTapped:(UISegmentedControl*)view
{
    if(isUsingTool)
    {
        [_current popOutOfView];
    }
    //NSString *tool=_tools[_toolBar.selectedSegmentIndex];
    //NSLog(@"%@ selected",tool);
    popupToolView *new;
    NSString *option=_tools[[view selectedSegmentIndex]];
    CGRect newRect=CGRectMake(thumbnailBorderWidth, thumbnailBorderWidth*2+_toolBar.frame.size.height, self.view.frame.size.width-2*thumbnailBorderWidth, self.view.frame.size.height-thumbnailBorderWidth*3-_toolBar.frame.size.height);
    if([self class]==[textToolViewController class])
    {
        if([option isEqualToString:@"Color"])
        {
            new=[[colorPopupToolView alloc] initWithFrame:newRect];
            [new configureWithToolType:LTpopupBorderColorTool];
        }
        else if([option isEqualToString:@"Font"])
        {
            new=[[fontPopupToolView alloc] initWithFrame:newRect];
            [new configureWithToolType:LTpopupFontTool];
        }
        else if([option isEqualToString:@"Alignment"])
        {
            new=[[textAlignmentPopupToolView alloc] initWithFrame:newRect];
            [new configureWithToolType:LTpopupTextAlignmentTool];
        }

    }
    else
    {
        if([option isEqualToString:@"Shade"])
        {
            new=[[colorPopupToolView alloc] initWithFrame:newRect];
            [new configureWithToolType:LTpopupBorderShadeTool];
        }
        else if([option isEqualToString:@"Color"])
        {
            new=[[colorPopupToolView alloc] initWithFrame:newRect];
            [new configureWithToolType:LTpopupBorderColorTool];
        }

    }
    new.controller=self;
    [self.view addSubview:new];
    [self.view bringSubviewToFront:new];
    _current=new;
    _current.alpha=1.0f;
    [_current popIntoView];
    [self setIsUsingTool:YES];
    [self.view layoutIfNeeded];
    
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

//Smartlayerthumbnailmanager methods
-(void)layerWasPoppedForThumbnail:(smartLayerThumbnail *)nail
{
    [self removeActiveThumbnail:nail];
}

-(void)thumbnailCenterDidEnterTrashFrame:(smartLayerThumbnail *)nail
{
    [[imageEditorView sharedInstance] removeSelectedLayer];
}

-(void)generateTools{}

//uigesturerecognizerdelegate method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)isUsingTool
{
    return isUsingTool;
}

-(void)setIsUsingTool:(BOOL)isIt
{
    isUsingTool=isIt;
    if(isIt)
    {
        [_superController toolKitDidBeginUsingTool];
    }
    else
    {
        [_superController toolKitDidEndUsingTool];
    }
}

-(void)layerWasSelected:(smartLayerThumbnail *)nail
{
    hasSelected=YES;
    [_toolBar setUserInteractionEnabled:YES];
}

-(void)layerWasDeselected:(smartLayerThumbnail *)nail
{
    hasSelected=NO;
    [_toolBar setUserInteractionEnabled:NO];
}

@end
