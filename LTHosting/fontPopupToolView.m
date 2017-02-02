//
//  fontPopupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "fontPopupToolView.h"

@implementation fontPopupToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self.slider removeFromSuperview];
    self.slider=nil;
    _fontPicker=[[horizontalViewPicker alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_fontPicker setDataSource:self];
    [_fontPicker setHDelegate:self];
    [_fontPicker.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self addSubview:_fontPicker];
    [self layoutIfNeeded];
    return self;
}

-(void)configureWithToolType:(popupType)type
{
    self.type=type;
    self.responder=[[imageEditorView sharedInstance] selectedLayer];
    if(type==LTpopupFontTool)
    {
        
    }
}

-(NSInteger)numberOfViews
{
    return [usefulArray bodyFontPostScriptNames].count;
}

-(UIView*)viewForIndex:(NSInteger)index
{
    return [self viewForFontName:[usefulArray bodyFontPostScriptNames][index]];
}

-(UIView*)viewForFontName:(NSString*)fontName
{
    CGRect modelFrame=CGRectMake(0, 0, 100, 100);
    
    UIFont *theFont=[UIFont fontWithName:fontName size:32];
    UILabel *label=[[UILabel alloc] initWithFrame:modelFrame];
    [label setText:@"Test"];
    [label setFont:theFont];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    [label.layer setCornerRadius:4];
    [label.layer setMasksToBounds:YES];
    [label setContentMode:UIViewContentModeCenter];
    
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setUserInteractionEnabled:YES];
    [label setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    return label;
}

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"called");
    UIFont *theFont=[UIFont fontWithName:[usefulArray bodyFontPostScriptNames][index] size:12];
    [self.responder fontDidChangeTo:theFont];
    
    [self popOutOfView];
    [self.controller.toolBar setSelectedSegmentIndex:-1];
}

-(BOOL)shouldHandleViewResizing
{
    return NO;
}

-(BOOL)shouldUseLabels
{
    return NO;
}

@end
