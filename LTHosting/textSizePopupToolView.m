//
//  textSizePopupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textSizePopupToolView.h"

@interface textSizePopupToolView(){
    NSInteger minimumFontSize;
    NSInteger maximumFontSize;
}
@end

@implementation textSizePopupToolView

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
    minimumFontSize=12;
    maximumFontSize=36;
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    minimumFontSize=12;
    maximumFontSize=36;
    return self;
}

-(void)configureWithToolType:(popupType)type
{
    [self.slider setMinimumValue:0.0f];
    [self.slider setMaximumValue:1.0f];
    switch(type)
    {
        case LTpopupTitleTextSizeTool:
        {
            self.responder=[[imageEditorView sharedInstance] titleLayer];
            break;
        }
        case LTpopupBodyTextSizeTool:
        {
            self.responder=[[imageEditorView sharedInstance] bodyLayer];
            break;
        }
        default:
            break;
    }
    
}

-(CGFloat)valueForTextSize:(CGFloat)textSize
{
    CGFloat total=maximumFontSize-minimumFontSize;
    return (textSize-minimumFontSize)/total;
}

-(CGFloat)textSizeForValue:(CGFloat)value
{
    return minimumFontSize+(maximumFontSize-minimumFontSize)*value;
}

-(void)setResponder:(id<popupToolResponder>)responder
{
    [super setResponder:responder];
    maximumFontSize=[responder maxTextSize];
    [self.slider setValue:[self valueForTextSize:[responder fontSize]]];
    NSLog(@"%f",[self valueForTextSize:[responder fontSize]]);
}

-(IBAction)sliderChanged:(UISlider*)slider
{
    [self.responder fontSizeDidChangeTo:[self textSizeForValue:self.slider.value]];
}

@end
