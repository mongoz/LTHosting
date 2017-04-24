//
//  toolsContainer.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "toolsContainer.h"
#import "toolView.h"

@interface toolsContainer(){
    HMSegmentedControl *bottom;
    
    toolView *activeToolView;
    CGFloat bottomHeight;
    BOOL barShowing;
}

@end

@implementation toolsContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//This array dictates the order the options are presented in the segmented control
static toolType types[]={titleTextTool, bodyTextTool, borderTool};
NSInteger tCount=3;

-(NSArray<NSString*>*)titles
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    for(NSInteger i=0; i<tCount; i++)
    {
        switch(types[i])
        {
            case borderTool:
                [temp addObject:@"Border"];
                break;
            case bodyTextTool:
                [temp addObject:@"Body"];
                break;
            case titleTextTool:
                [temp addObject:@"Title"];
                break;
            default:
                break;
        }
    }
    return temp;
}

-(CGRect)contentFrame
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-bottom.frame.size.height);
}


-(id)init
{
    self=[super init];
    [self configure];
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self configure];
}

-(void)configure{
    bottomHeight=40.0f;
    barShowing=NO;
    bottom=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, MAX(self.frame.size.height-bottomHeight,0), self.frame.size.width, bottomHeight)];
    [self addSubview:bottom];
    [bottom setSectionTitles:[self titles]];
    [bottom setType:HMSegmentedControlTypeText];
    [bottom setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [bottom setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [bottom setSelectionIndicatorColor:[UIColor blackColor]];
    [bottom setShouldAnimateUserSelection:YES];
    [bottom setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [bottom setTitleTextAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    __weak typeof(self) ref=self;
    [bottom setIndexChangeBlock:^(NSInteger index){
        [ref segmentChangedTo:index];
    }];
    
    activeToolView=nil;
    
    [self transitionToTool:types[0] completion:nil];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [bottom setFrame:CGRectMake(0, self.frame.size.height-bottomHeight, self.frame.size.width, bottomHeight)];
    if(activeToolView!=nil)
    {
        [activeToolView setFrame:[self contentFrame]];
    }
}

-(void)segmentChangedTo:(NSInteger)index
{
    [self transitionToTool:types[index] completion:nil];
}

-(void)transitionToTool:(toolType)tool completion:(void(^)())completionBlock
{
    __weak toolView *old=activeToolView;
    activeToolView=[[toolView alloc] initWithFrame:[self contentFrame] type:tool container:self];
    activeToolView.hidden=YES;
    [activeToolView layoutIfNeeded];
    [self addSubview:activeToolView];
    [activeToolView dissolveIn:YES completion:^{
        if(old!=nil)
        {
            [old removeFromSuperview];
        }
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
    
}

UIButton *barView=nil;

-(void)toolView:(toolView *)view isEditingWillChangeTo:(BOOL)isEditing
{
    if(barShowing!=isEditing)
    {
        [self toggleBar];
    }
    bottom.userInteractionEnabled=!isEditing;
}

-(void)toggleBar
{
    BOOL up=NO;
    if(barView==nil)
    {
        up=YES;
        CGRect superFrame=self.frame;
        CGRect barFrame=CGRectMake(0, superFrame.size.height, activeToolView.frame.size.width, superFrame.size.height-activeToolView.frame.size.height);
        barView=[[UIButton alloc] initWithFrame:barFrame];
        [barView setBackgroundColor:[UIColor redColor]];
        [barView setTitle:@"Done" forState:UIControlStateNormal];
        [barView addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:barView];
    }
    CGFloat heightChange=barView.frame.size.height;
    if(up)
    {
        heightChange*=-1;
    }
    CGRect newFrame=CGRectMake(barView.frame.origin.x, barView.frame.origin.y+heightChange, barView.frame.size.width, barView.frame.size.height);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:.25 animations:^{
            [barView setFrame:newFrame];
        } completion:^(BOOL finished){
            if(!up)
            {
                [barView removeFromSuperview];
                barView=nil;
            }
            barShowing=!barShowing;
        }];
    }];
    
}

-(IBAction)donePressed:(UIButton*)done
{
    [activeToolView endUsingTool];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(activeToolView!=nil)
    {
        [activeToolView willAppear];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(activeToolView!=nil)
    {
        [activeToolView willDisappear];
    }
}

@end
