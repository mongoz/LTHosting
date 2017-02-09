//
//  flyerViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerViewController.h"
#import "commonUseFunctions.h"
#import "usefulArray.h"
#import "eventCameraViewController.h"

@interface flyerViewController (){
    UIView *current;
    
    CGRect targetBorderFrame;
    CGRect targetTextFrame;
    
    UIImage *thumbnailImage;
    
    UISegmentedControl *toolChooser;
    
    flexibleIlluminatedButton *editingButton;
    
    
    UIVisualEffectView *editingView;
    toolKitViewController *editingController;
    
    horizontalViewPicker *borderPicker;
    
    UIView *textEditorView;
    
    BOOL isEditing;
    
    NSArray<NSString*>* textTypes;
    NSInteger typeIndex;
    
    UIView *textInputView;
}
@end

@implementation flyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEditing=NO;
    editingView=nil;
    editingController=nil;
    textInputView=nil;
    // Do any additional setup after loading the view.
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_imageContainerView setAutoresizesSubviews:YES];
    CGFloat proportion=750.0f/836.0f;
    [[imageEditorView sharedInstance] setFrame:CGRectMake(_imageContainerView.frame.size.width/2-(_imageContainerView.frame.size.height*proportion)/2, 0, _imageContainerView.frame.size.height*proportion, _imageContainerView.frame.size.height)];
    NSLog(@"versus: %f, %f",_imageContainerView.frame.size.width,(_imageContainerView.frame.size.height*proportion));
    [_imageContainerView addSubview:[imageEditorView sharedInstance]];
    
    UIImage *im=[[event sharedInstance] image];
    thumbnailImage=im;
    borderPicker=[[horizontalViewPicker alloc] initWithFrame:_toolView.bounds];
    borderPicker.bounces=NO;
    [borderPicker setHeightWidthRatio:830.0f/750.0f];
    [borderPicker setHDelegate:self];
    [borderPicker setDataSource:self];
    [borderPicker selectRowAtIndex:0];
    [_toolView addSubview:borderPicker];
    
    textEditorView=[self textEditorWithFrame:_toolView.bounds];
    [textEditorView setFrame:CGRectMake(textEditorView.frame.origin.x+textEditorView.frame.size.width, textEditorView.frame.origin.y, textEditorView.frame.size.width, textEditorView.frame.size.height)];
    [_toolView addSubview:textEditorView];
    
    
    current=borderPicker;
    
    
    toolChooser=[[UISegmentedControl alloc] initWithItems:@[@"Border", @"Text"]];
    [toolChooser setSelectedSegmentIndex:0];
    [toolChooser setSelected:YES];
    
    CGFloat margin=6.0f;
    CGFloat width=_bottomBarView.frame.size.width/3.0f;
    editingButton=[[flexibleIlluminatedButton alloc] initWithFrame:CGRectMake(_bottomBarView.frame.size.width/2-width/2, margin, width, _bottomBarView.frame.size.height-margin*2)];
    [editingButton setTitle:@"Editing: NO" forState:UIControlStateNormal];
    editingButton.responder=self;
    editingButton.flexibleSource=self;
    editingButton.userInteractionEnabled=NO;
    [_bottomBarView addSubview:editingButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[imageEditorView sharedInstance] updateImageContainerWithImage:thumbnailImage];
    [[imageEditorView sharedInstance] setTitleAndBodyText];
    [[[imageEditorView sharedInstance] bodyLayer] fontSizeDidChangeTo:[[imageEditorView sharedInstance] bodyLayer].maxTextSize];
    [[[imageEditorView sharedInstance] titleLayer] fontSizeDidChangeTo:[[imageEditorView sharedInstance] titleLayer].maxTextSize];
}


-(UIView*)textEditorWithFrame:(CGRect)frame
{
    UIView *new=[[UIView alloc] initWithFrame:frame];
    CGFloat margin=16;
    CGRect bodyFrame=CGRectMake(frame.origin.x+margin, frame.origin.y+margin, (frame.size.width-3.0f*margin)/2.0f, frame.size.height-2*margin);
    CGRect titleFrame=CGRectMake(bodyFrame.origin.x+bodyFrame.size.width+margin, bodyFrame.origin.y, bodyFrame.size.width, bodyFrame.size.height);
    UIButton *titleButton=[[UIButton alloc] initWithFrame:titleFrame];
    UIButton *bodyButton=[[UIButton alloc] initWithFrame:bodyFrame];
    
    [titleButton.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [titleButton.layer setCornerRadius:8.0f];
    [titleButton.layer setMasksToBounds:YES];
    [titleButton setTitle:@"Set Title Text" forState:UIControlStateNormal];
    [titleButton.titleLabel setTextColor:[UIColor whiteColor]];
    [titleButton addTarget:self action:@selector(editTitleText:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [titleButton.layer setBorderWidth:2.0f];
    
    [bodyButton.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [bodyButton.layer setCornerRadius:8.0f];
    [bodyButton.layer setMasksToBounds:YES];
    [bodyButton setTitle:@"Set Body Text" forState:UIControlStateNormal];
    [bodyButton.titleLabel setTextColor:[UIColor whiteColor]];
    [bodyButton addTarget:self action:@selector(editBodyText:) forControlEvents:UIControlEventTouchUpInside];
    [bodyButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [bodyButton.layer setBorderWidth:2.0f];
    
    [new addSubview:titleButton];
    [new addSubview:bodyButton];
    return new;
}

-(IBAction)editBodyText:(id)sender{
    [self beginTextEditingWithTextLayer:[[imageEditorView sharedInstance] bodyLayer]];
}

-(IBAction)editTitleText:(id)sender{
    [self beginTextEditingWithTextLayer:[[imageEditorView sharedInstance] titleLayer]];
}

__weak smartTextLayer *editingLayer=nil;

-(void)beginTextEditingWithTextLayer:(smartTextLayer*)layer
{
    if(editingLayer!=nil)
    {
        return;
    }
    editingLayer=layer;
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *shade=[[UIVisualEffectView alloc] initWithEffect:blur];
    [shade setFrame:self.view.bounds];
    UITextView *editor=[[UITextView alloc] initWithFrame:shade.bounds];
    [editor setBackgroundColor:[UIColor clearColor]];
    [editor setInputAccessoryView:[self inputAccessoryView]];
    if(layer!=nil)
    {
        [editor setText:layer.textLayer.text];
        [editor setFont:[layer.textLayer.font fontWithSize:layer.textLayer.font.pointSize*self.view.frame.size.width/layer.frame.size.width]];
        [editor setTextAlignment:layer.textLayer.textAlignment];
        [editor setTextColor:layer.textLayer.textColor];
    }
    [shade addSubview:editor];
    [shade bringSubviewToFront:editor];
    [editor setTextColor:[UIColor whiteColor]];
    [editor setFont:[UIFont fontWithName:@"Keep Calm" size:32]];
    [self.view addSubview:shade];
    [self.view bringSubviewToFront:shade];
    editor.delegate=self;
    [editor becomeFirstResponder];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textEditingLayerTapped:)];
    [editor addGestureRecognizer:tap];
    
    textInputView=shade;
    //[shade setFrame:CGRectMake(shade.frame.origin.x, shade.frame.origin.y, shade.frame.size.width, self.superview.frame.size.height-self.frame.origin.y-keyboardFrame.size.height)];
}

-(IBAction)textEditingLayerTapped:(UITapGestureRecognizer*)tap
{
    [self shouldEndTextEditing];
}

-(UIView*)keyboardAccessory
{
    CGFloat height=44;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height)];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    UIButton *revert=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, height)];
    [revert setTitle:@"Revert" forState:UIControlStateNormal];
    [revert addTarget:self action:@selector(revertTextEditingChanges:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *commit=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, height)];
    [commit setTitle:@"Commit" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitTextEditingChanges:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:revert];
    [view addSubview:commit];
    
    return view;
}

-(IBAction)revertTextEditingChanges:(id)sender
{
    
}

-(IBAction)commitTextEditingChanges:(id)sender{
    
}

-(void)shouldEndTextEditing
{
    [self endTextEditing];
}

-(void)endTextEditing
{
    if(textInputView!=nil)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for(UIView *v in textInputView.subviews)
            {
                if(v.class==[UITextView class])
                {
                    [v endEditing:YES];
                    [editingLayer setText:[(UITextView*)v text]];
                    BOOL hadFlex=NO;
                    if(editingLayer.flexibleHeight)
                    {
                        hadFlex=YES;
                    }
                    editingLayer.flexibleHeight=NO;
                    editingLayer.frame=editingLayer.frame;
                    if(hadFlex)
                    {
                        editingLayer.flexibleHeight=YES;
                    }
                }
            }
            editingLayer=nil;
            [textInputView removeFromSuperview];
            textInputView=nil;
        }];
    }
}

-(IBAction)textSelectorChanged:(id)sender{
    
}

-(void)toolsDidMove
{
    [editingButton reloadData];
}

-(void)illuminatedButton:(illuminatedButton *)button stateDidChangeTo:(BOOL)illuminated
{
}

-(void)illuminatedButton:(illuminatedButton *)button stateWillChangeTo:(BOOL)illuminated
{
    __block BOOL wait=NO;
    if(isEditing)
    {
        wait=YES;
        [self endEditing:^{
            wait=NO;
        }];
    }
    while(wait)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    flexibleIlluminatedButton *myButton=(flexibleIlluminatedButton*)button;
    if([self isIlluminatedAtTitleWithIndex:[myButton currentIndex]])
    {
        [self beginEditing:nil];
    }
}

-(void)beginEditing:(void(^)())completion
{
    if(editingView!=nil)
    {
        return;
    }
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    editingView=[[UIVisualEffectView alloc] initWithEffect:blur];
    [editingView setFrame:_toolView.bounds];
    editingView.alpha=.75;
    if(current==borderPicker)
    {
        editingController=[[borderToolViewController alloc] init];
        
    }
    else if(current==textEditorView)
    {
        if([editingButton currentIndex]==1)
        {
            editingController=[[textToolViewController alloc] initWithType:bodyTextToolViewController];
        }
        else if([editingButton currentIndex]==2)
        {
            editingController=[[textToolViewController alloc] initWithType:titleTextToolViewController];
        }
    }
    [editingController.view setFrame:_toolView.bounds];
    [self addChildViewController:editingController];
    CGFloat y=editingController.toolBar.frame.origin.y*2+editingController.toolBar.frame.size.height;
    UILabel *instruct=[[UILabel alloc] initWithFrame:CGRectMake(editingController.toolBar.frame.origin.x, y, editingController.toolBar.frame.size.width, editingController.view.frame.size.height-y-editingController.toolBar.frame.origin.y)];
    [instruct setText:@"Select a tool to begin editing"];
    [instruct setFont:[UIFont boldSystemFontOfSize:18]];
    [instruct setTextAlignment:NSTextAlignmentCenter];
    [instruct setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [instruct setTextColor:[UIColor darkGrayColor]];
    [instruct setAlpha:.75];
    [editingView addSubview:instruct];
    [editingView addSubview:editingController.view];
    [editingView setAlpha:0.0f];
    [_toolView addSubview:editingView];
    [UIView animateWithDuration:.5 animations:^{
        [editingView setAlpha:1.0f];
    } completion:^(BOOL finished){
        isEditing=YES;
        if(completion!=nil)
        {
            completion();
        }
    }];
}

-(void)endEditing:(void(^)())completion
{
    [UIView animateWithDuration:.5 animations:^{
        [editingView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [editingView removeFromSuperview];
        editingView=nil;
        [editingController removeFromParentViewController];
        editingController=nil;
        isEditing=NO;
        if(completion!=nil)
        {
            completion();
        }
    }];
}

-(NSInteger)numberOfStatesForFlexibleButton
{
    if(toolChooser.selectedSegmentIndex==0)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

-(NSString*)flexibleIlluminatedButton:(flexibleIlluminatedButton *)button titleForIndex:(NSInteger)index
{
    if(toolChooser.selectedSegmentIndex==0)
    {
        switch(index)
        {
            case 0:
                return @"Editing: NO";
            case 1:
                return @"Editing: YES";
        }
    }
    else
    {
        switch(index)
        {
            case 0:
                return @"Editing: NO";
            case 1:
                return @"Editing: Body";
            case 2:
                return @"Editing: Title";
        }
    }
    return @"Editing: NO";
}

-(BOOL)isIlluminatedAtTitleWithIndex:(NSInteger)index
{
    if(toolChooser.selectedSegmentIndex==0)
    {
        switch(index)
        {
            case 0:
                return NO;
            case 1:
                return YES;
        }
    }
    else
    {
        switch(index) {
            case 0:
                return NO;
            case 1:
                return YES;
            case 2:
                return YES;
        }
        
    }
    return NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat margin=4;
    _topBarView=self.navigationController.navigationBar;
    CGFloat width=_topBarView.frame.size.width/3.0f;
    [toolChooser setFrame:CGRectMake(_topBarView.frame.size.width/2-width/2, margin+self.topLayoutGuide.length, width, _topBarView.frame.size.height-self.topLayoutGuide.length-margin*2)];
    [toolChooser setTintColor:[UIColor whiteColor]];
    [toolChooser addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:toolChooser];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(IBAction)segmentChanged:(UISegmentedControl*)control
{
    if(isEditing)
    {
        [editingButton changeState];
        while(isEditing)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
        }
    }
    if([control selectedSegmentIndex]==0)
    {
        [self moveToolsOverBy:self.view.frame.size.width left:NO];
        current=borderPicker;
    }
    else
    {
        [self moveToolsOverBy:-self.view.frame.size.width left:NO];
        current=textEditorView;
        [editingButton setUserInteractionEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"cancelEditing"]) {
        [imageEditorView reset];
        for(UIView *view in self.view.subviews)
        {
            [view removeFromSuperview];
        }
        for(CALayer *layer in self.view.layer.sublayers)
        {
            [layer removeFromSuperlayer];
        }
    }
}


- (IBAction)doneButtonPressed:(id)sender {
    UIImage *image=[[imageEditorView sharedInstance] currentImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
- (IBAction)backButtonPressed:(id)sender {
    eventCameraViewController *cam=(eventCameraViewController*)self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
    [self.navigationController popViewControllerAnimated:YES];
    [cam prepareForUnwind:[UIStoryboardSegue segueWithIdentifier:@"cancelEditing" source:self destination:cam performHandler:^{
        
    }]];
}

-(void)moveToolsOverBy:(CGFloat)distance left:(BOOL)left
{
    CGFloat scaler=1.0f;
    if(left)
    {
        scaler=-1.0f;
    }
    if(((!left&&distance>0)||(left&&distance<0))&&textEditorView.frame.origin.x>0)
    {
        scaler/=sqrt(sqrt(fabs(textEditorView.frame.origin.x)));
    }
    else if(((left&&distance>0)||(!left&&distance<0))&&borderPicker.frame.origin.x<0)
    {
        scaler/=sqrt(sqrt(fabs(borderPicker.frame.origin.x)));
    }
    
    
    CGRect textNow=textEditorView.frame;
    CGRect bordersNow=borderPicker.frame;
    CGRect newTextRect=CGRectMake(textNow.origin.x+(scaler*distance), textNow.origin.y, textNow.size.width, textNow.size.height);
    CGRect newBorderRect=CGRectMake(bordersNow.origin.x+(scaler*distance), bordersNow.origin.y, bordersNow.size.width, bordersNow.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [borderPicker setFrame:newBorderRect];
        [textEditorView setFrame:newTextRect];
    } completion:^(BOOL finished){
        [self toolsDidMove];
    }];
    
}

-(void)setCurrent:(UIView*)new
{
    current=new;
    [self calculateTargetFrames];
}

-(void)calculateTargetFrames
{
    CGRect toolFrame=_toolView.bounds;
    if(current==textEditorView)
    {
        targetTextFrame=toolFrame;
        targetBorderFrame=CGRectMake(toolFrame.origin.x+toolFrame.size.width, toolFrame.origin.y, toolFrame.size.width, toolFrame.size.height);
    }
    else
    {
        targetBorderFrame=toolFrame;
        targetTextFrame=CGRectMake(toolFrame.origin.x-toolFrame.size.width, toolFrame.origin.y, toolFrame.size.width, toolFrame.size.height);
    }
}

-(void)slideToTargetFrames
{
    CGFloat dist=targetBorderFrame.origin.x-borderPicker.frame.origin.x;
    BOOL left=NO;
    if(dist<0)
    {
        left=YES;
        dist=-dist;
    }
    [self moveToolsOverBy:dist left:left];
}


//toolkitsupercontroller methods
-(void)toolKitDidBeginUsingTool
{
    
}

-(void)toolKitDidEndUsingTool
{
    
}

//uigesturrecognizer method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

//Horizontalviewpicker methods
-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index{
    
    if(index==0)
    {
        [[[imageEditorView sharedInstance] borderLayer] setContents:nil];
        [editingButton setUserInteractionEnabled:NO];
    }
    else
    {
        [[[imageEditorView sharedInstance] borderLayer] setContents:(id)[usefulArray borderImages][index-1].CGImage];
        [editingButton setUserInteractionEnabled:YES];
    }
}

-(NSInteger)numberOfViews
{
    return [usefulArray borderImages].count+1;
}

-(UIView*)viewForIndex:(NSInteger)index{
    UIImageView *base=[[UIImageView alloc] initWithImage:thumbnailImage];
    [base setBackgroundColor:[UIColor blackColor]];
    [base.layer setContentsGravity:kCAGravityResizeAspectFill];
    [base setAutoresizesSubviews:YES];
    [base setTranslatesAutoresizingMaskIntoConstraints:YES];
    [base.layer setMasksToBounds:YES];
    [base setFrame:CGRectMake(0, 0, 100, 100)];
    if(index==0)
    {
        return base;
    }
    UIImage *im=[usefulArray borderImages][index-1];
    CGSize newSize=CGSizeMake(_toolView.frame.size.height, _toolView.frame.size.height*836.0f/750.0f);
    UIImageView *new=[[UIImageView alloc] initWithImage:[self resizeImage:im newSize:newSize]];
    [new setContentMode:UIViewContentModeScaleToFill];
    [new setFrame:base.frame];
    [base addSubview:new];
    return base;
}

-(BOOL)shouldHandleViewResizing
{
    return YES;
}

-(BOOL)shouldUseLabels
{
    return YES;
}

-(NSString*)labelForIndex:(NSInteger)index
{
    if(index==0)
    {
        return @"None";
    }
    return [usefulArray borderNames][index-1];
}

-(UIView*)view:(UIView *)view inFrame:(CGRect)frame
{
    [view setFrame:frame];
    for(UIView *vi in view.subviews)
    {
        [vi setFrame:view.bounds];
    }
    return view;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
