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
#import "toolViewItem.h"
#import "tool.h"

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
    [_toolPicker setHeightWidthRatio:640.0f/480.0f];
    _toolPicker.hDelegate=self;
    _toolPicker.dataSource=self;
    _toolPicker.showsSelection=NO;
    [self addSubview:_toolPicker];
    activeTool=nil;
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
            [self setBackgroundColor:[UIColor yellowColor]];
            break;
        case titleTextTool:
            [self setBackgroundColor:[UIColor greenColor]];
            break;
        default:
            break;
    }
    _myType=type;
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
            [self setBackgroundColor:[UIColor redColor]];
            break;
        case bodyTextTool:
            [self setBackgroundColor:[UIColor yellowColor]];
            break;
        case titleTextTool:
            [self setBackgroundColor:[UIColor greenColor]];
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
    return (UIView*)[self items][index];
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
    return NO;
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

@end
