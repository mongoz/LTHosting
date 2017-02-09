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
    [_fontPicker setHDelegate:self];
    [_fontPicker setDataSource:self];
    [_fontPicker.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self addSubview:_fontPicker];
    [self layoutIfNeeded];
    return self;
}

-(void)configureWithToolType:(popupType)type
{
    self.type=type;
    if(type==LTpopupBodyFontTool)
    {
        self.responder=[[imageEditorView sharedInstance] bodyLayer];
    }
    else if(type==LTpopupTitleFontTool)
    {
        self.responder=[[imageEditorView sharedInstance] titleLayer];
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
    
    UIFont *theFont=[UIFont fontWithName:fontName size:100];
    UILabel *label=[[UILabel alloc] initWithFrame:modelFrame];
    [label setText:@"A"];
    [label setFont:theFont];
    [label setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [label.layer setCornerRadius:4];
    [label.layer setMasksToBounds:YES];
    [label setContentMode:UIViewContentModeCenter];
    
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setUserInteractionEnabled:YES];
    [label setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    
    return label;
}

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index
{
    UIFont *theFont=[UIFont fontWithName:[usefulArray bodyFontPostScriptNames][index] size:12];
    [self.responder fontDidChangeTo:theFont];
}

-(BOOL)shouldHandleViewResizing
{
    return YES;
}

-(UIView*)view:(UIView *)view inFrame:(CGRect)frame
{
    UILabel *label=(UILabel*)view;
    [label setFrame:frame];
    CGFloat margin=frame.size.height/10;
    [label setTextAlignment:NSTextAlignmentCenter];
    while(label.attributedText.size.height>label.frame.size.width-margin*2)
    {
        [label setFont:[label.font fontWithSize:label.font.pointSize-1]];
    }
    return label;
}

-(BOOL)shouldUseLabels
{
    return NO;
}

@end
