//
//  flyerViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerViewController.h"
#import "commonUseFunctions.h"

@interface flyerViewController (){
    borderToolViewController *borderTools;
    textToolViewController *texttools;
    
    toolKitViewController *current;
    
    CGPoint panPoint;
    CGPoint panVel;
    NSInteger panHelper;
    
    CGFloat k;
    CGFloat m;
    CGFloat u;
    CGFloat v;
    CGFloat d;
    
    CGRect targetBorderFrame;
    CGRect targetTextFrame;
    
    CGFloat bouncingTimeInterval;
    
    UIPanGestureRecognizer *pan;
    
}
@end

@implementation flyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    panPoint=CGPointZero;
    panHelper=0;
    panVel=CGPointZero;
    
    bouncingTimeInterval=.2;
    // Do any additional setup after loading the view.
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    [[imageEditorView sharedInstance] updateImageContainer];
    [_imageContainerView setAutoresizesSubviews:YES];
    [[imageEditorView sharedInstance] setFrame:_imageContainerView.bounds];
    [_imageContainerView addSubview:[imageEditorView sharedInstance]];
    [self createToolViews];
    pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
    [pan setMaximumNumberOfTouches:1];
    [pan setDelaysTouchesBegan:TRUE];
    [pan setDelaysTouchesEnded:YES];
    [pan setCancelsTouchesInView:YES];
    [pan setDelegate:self];
    [_toolView addGestureRecognizer:pan];
    current=borderTools;
    k=2.5;
    m=15;
    u=.9*9.8;
}

-(IBAction)panFired:(UIPanGestureRecognizer*)panG
{
    if([current isUsingTool])
    {
        return;
    }
    CGPoint loc=[panG locationInView:_toolView];
    
    if([panG state]==UIGestureRecognizerStateEnded)
    {
        panPoint=CGPointZero;
        panHelper=0;
        panVel=CGPointZero;
        [self slideToTargetFrames];
        
    }
    else
    {
        if(panPoint.x!=CGPointZero.x||panPoint.y!=CGPointZero.y)
        {
            CGSize diff=CGSizeMake(loc.x-panPoint.x, loc.y-panPoint.y);
            BOOL left=NO;
            if(diff.width<0)
            {
                left=YES;
                diff.width=-diff.width;
            }
            [self moveToolsOverBy:diff.width left:left];
        }
        panPoint=loc;
        panVel=[panG velocityInView:_toolView];
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
        [[imageEditorView sharedInstance] reset];
    }
}


- (IBAction)doneButtonPressed:(id)sender {
    UIImage *image=[[imageEditorView sharedInstance] currentImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
- (IBAction)backButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"cancelEditing" sender:nil];
}
- (IBAction)editTextButtonPressed:(id)sender {
}
- (IBAction)editBordersButtonPressed:(id)sender {
    //[self transitionToToolWithName:@"border"];
}

-(void)createToolViews
{
    borderTools=[[borderToolViewController alloc] init];
    borderTools.superController=self;
    texttools=[[textToolViewController alloc] init];
    texttools.superController=self;
    [borderTools.view setFrame:_toolView.bounds];
    [texttools.view setFrame:CGRectMake(_toolView.bounds.origin.x-_toolView.bounds.size.width, _toolView.bounds.origin.y, _toolView.bounds.size.width, _toolView.bounds.size.height)];
    [_toolView addSubview:borderTools.view];
    [_toolView addSubview:texttools.view];
    targetTextFrame=texttools.view.frame;
    targetBorderFrame=borderTools.view.frame;
    
    current=borderTools;
}

-(void)moveToolsOverBy:(CGFloat)distance left:(BOOL)left
{
    CGFloat scaler=1.0f;
    if(left)
    {
        scaler=-1.0f;
    }
    if(((!left&&distance>0)||(left&&distance<0))&&texttools.view.frame.origin.x>0)
    {
        scaler/=sqrt(sqrt(fabs(texttools.view.frame.origin.x)));
    }
    else if(((left&&distance>0)||(!left&&distance<0))&&borderTools.view.frame.origin.x<0)
    {
        scaler/=sqrt(sqrt(fabs(borderTools.view.frame.origin.x)));
    }
    
    
    CGRect textNow=texttools.view.frame;
    CGRect bordersNow=borderTools.view.frame;
    CGRect newTextRect=CGRectMake(textNow.origin.x+(scaler*distance), textNow.origin.y, textNow.size.width, textNow.size.height);
    CGRect newBorderRect=CGRectMake(bordersNow.origin.x+(scaler*distance), bordersNow.origin.y, bordersNow.size.width, bordersNow.size.height);
    [UIView animateWithDuration:bouncingTimeInterval animations:^{
        [borderTools.view setFrame:newBorderRect];
        [texttools.view setFrame:newTextRect];
    } completion:^(BOOL finished){
        CGFloat scrollMinProp=3;
        if(current==borderTools&&borderTools.view.frame.origin.x>self.view.frame.size.width/scrollMinProp)
        {
            [self setCurrent:texttools];
        }
        else if(current==texttools&&borderTools.view.frame.origin.x<self.view.frame.size.width/scrollMinProp)
        {
            [self setCurrent:borderTools];
        }
    }];
    
}

-(void)setCurrent:(toolKitViewController*)new
{
    current=new;
    [self calculateTargetFrames];
}

-(void)calculateTargetFrames
{
    CGRect toolFrame=_toolView.bounds;
    if(current==texttools)
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
    CGFloat dist=targetBorderFrame.origin.x-borderTools.view.frame.origin.x;
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
    [_toolView removeGestureRecognizer:pan];
}

-(void)toolKitDidEndUsingTool
{
    [_toolView addGestureRecognizer:pan];
}

//uigesturrecognizer method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}


@end
