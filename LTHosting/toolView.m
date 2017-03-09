//
//  toolsView.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "toolView.h"
#import "editorView.h"
#import "borderToolView.h"
#import "textToolView.h"
#import "toolViewItem.h"
#import "tool.h"
#import "toolsContainer.h"

@interface toolView(){
    tool *activeTool;
}


@end

@implementation toolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self=[super init];
    _myType=toolTypeNone;
    _toolPicker=[[horizontalViewPicker alloc] init];
    _toolPicker.showsSelection=NO;
    _toolPicker.impliesContentSize=YES;
    [_toolPicker setHeightWidthRatio:1.0f];
    _toolPicker.hDelegate=self;
    _toolPicker.dataSource=self;
    _toolPicker.bounces=NO;
    [self addSubview:_toolPicker];
    activeTool=nil;
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return self;
}

-(id)initWithType:(toolType)type container:(toolsContainer *)cont
{
    self=[self init];
    switch(type)
    {
        case borderTool:
            self=[[borderToolView alloc] init];
            break;
        case bodyTextTool:
        case titleTextTool:
            self=[[textToolView alloc] init];
            break;
        default:
            break;
    }
    self.type=type;
    _container=cont;
    return self;
}

-(id)initWithFrame:(CGRect)frame type:(toolType)type container:(toolsContainer *)cont
{
    self=[self initWithType:type container:cont];
    [self setFrame:frame];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_toolPicker setFrame:self.bounds];
}

//Managing type
-(toolType)type
{
    return _myType;
}

-(void)setType:(toolType)type
{
    _myType=type;
    [self configureType];
}

-(void)configureType
{
    if(_myType==toolTypeNone)
    {
        return;
    }
    switch(_myType)
    {
        case borderTool:
            break;
        case bodyTextTool:
            break;
        case titleTextTool:
            break;
        default:
            break;
    }
    
}

//Fade in or out
-(void)dissolveIn:(BOOL)comingIn completion:(void (^)())completionBlock
{
    if(activeTool!=nil)
    {
        [activeTool dissolveIn:!comingIn completion:nil];
    }
    [UIView transitionWithView:self duration:.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.hidden=!comingIn;
    }completion:^(BOOL finished){
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}

//Horizontal View Picker
-(UIView*)viewForIndex:(NSInteger)index
{
    toolViewItem *view=[self items][index];
    return (UIView*)view;
}

-(BOOL)shouldUseLabels
{
    return NO;
}

-(NSInteger)numberOfViews
{
    return [self items].count;
}

-(BOOL)shouldHandleViewResizing
{
    return YES;
}

-(UIView*)view:(UIView *)view inFrame:(CGRect)frame
{
    [view setFrame:frame];
    [(toolViewItem*)view setLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    return view;
}

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index
{
    [self transitionToToolAtIndex:index completion:nil];
}

-(void)transitionToToolAtIndex:(NSInteger)index completion:(void(^)())completionBlock
{
    __block tool *new=nil;
    NSBlockOperation *createTool=[NSBlockOperation blockOperationWithBlock:^{
        new=[[self items][index] correspondingTool];
        [new setFrame:self.bounds];
        [new layoutIfNeeded];
        new.hidden=YES;
    }];
    [createTool setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            activeTool=new;
            [self addSubview:activeTool];
            [activeTool dissolveIn:YES completion:^{
                [self beginUsingTool:activeTool];
            }];
        }];
    }];
    [[NSOperationQueue new] addOperation:createTool];
}

-(IBAction)buttonTouchedDown:(UIButton*)button
{
    [self animateButton:button touchDown:YES completion:nil];
}

-(IBAction)buttonTouchedUpInside:(UIButton*)button
{
    [self animateButton:button touchDown:NO completion:nil];
}

-(IBAction)buttonTouchedUpOutside:(UIButton *)button
{
    [self animateButton:button touchDown:NO completion:nil];
}

-(void)animateButton:(UIButton*)button touchDown:(BOOL)down completion:(void(^)())completionBlock
{
    NSBlockOperation *block=[NSBlockOperation blockOperationWithBlock:^{
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
    }];
    [[NSOperationQueue mainQueue] addOperation:block];
}

-(void)beginUsingTool:(tool*)tool
{
    [_container toolView:self isEditingWillChangeTo:YES];
}

-(void)endUsingTool
{
    [activeTool dissolveIn:NO completion:nil];
    [_container toolView:self isEditingWillChangeTo:NO];
}

-(void)willAppear
{
    
}

-(void)willDisappear
{
    
}

-(BOOL)isHidden
{
    return self.alpha==0.0f;
}

-(void)setHidden:(BOOL)hidden
{
    if(hidden)
    {
        self.alpha=0.0f;
    }
    else
    {
        self.alpha=1.0f;
    }
}

@end
