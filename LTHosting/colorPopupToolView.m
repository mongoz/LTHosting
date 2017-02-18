//
//  colorPopupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "colorPopupToolView.h"

@interface colorPopupToolView(){
    UIButton *noColorButton;
}
@end

@implementation colorPopupToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    noColorButton=nil;
    self=[super initWithFrame:frame];
    [self.slider setContinuous:YES];
    [self.slider setMinimumValue:0];
    [self.slider setMaximumValue:1];
    [self setNoColorButton];
    return self;
}

-(void)setNoColorButton
{
    CGFloat inset=6;
    noColorButton=[[UIButton alloc] initWithFrame:CGRectMake(inset, inset, self.frame.size.height-inset*2, self.frame.size.height-inset*2)];
    [noColorButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [noColorButton.layer setBorderWidth:2];
    [noColorButton.layer setMasksToBounds:YES];
    [noColorButton.layer setCornerRadius:noColorButton.frame.size.height/2];
    [noColorButton addTarget:self action:@selector(noColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider setFrame:CGRectMake(noColorButton.frame.origin.x*2+noColorButton.frame.size.width, self.slider.frame.origin.y, self.slider.frame.size.width-(noColorButton.frame.origin.x+noColorButton.frame.size.width),self.slider.frame.size.height)];
    [self addSubview:noColorButton];
}

-(IBAction)noColor:(UIButton*)noColorButtona
{
    [self.responder removeColor];
    [noColorButtona.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [self.slider setValue:0.0f animated:YES];
}

-(void)addColorGradientToSlider
{
    [self addGradientToSliderWithColors:[self colorArray]];
}

-(NSArray<id>*)colorArray
{
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue<=300; hue += 5) {
        
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * hue / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    return  colors;
}

-(NSArray<id>*)shadeArray
{
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 360; hue>=0; hue -= 5) {
        
        UIColor *color;
        color = [UIColor colorWithWhite:hue/360.0f alpha:1.0f];
        [colors addObject:(id)[color CGColor]];
    }
    return colors;
}

-(void)addGradientToSliderWithColors:(NSArray<id>*)colors
{
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [gradientLayer setStartPoint:CGPointMake(0.0f, 0.5f)];
    [gradientLayer setEndPoint:CGPointMake(1.0f, 0.5f)];
    
    CGFloat gradientHeight=24;
    CGRect gradientFrame=[self.slider trackRectForBounds:self.slider.bounds];
    gradientFrame=CGRectMake(0, self.slider.bounds.size.height/2-gradientHeight/2, gradientFrame.size.width, gradientHeight);
    [gradientLayer setFrame:gradientFrame];
    [gradientLayer setCornerRadius:gradientHeight/2];
    [gradientLayer setBorderColor:[UIColor blackColor].CGColor];
    [gradientLayer setBorderWidth:2.0f];
    
    UIImage *layerImage=[UIImage imageForLayer:gradientLayer];
    layerImage=[layerImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [self.slider setMaximumTrackImage:layerImage forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:layerImage forState:UIControlStateNormal];
}

-(void)addShadeGradientToSlider
{
    [self addGradientToSliderWithColors:[self shadeArray]];
    
}

-(void)configureWithToolType:(popupType)type
{
    self.type=type;
    self.responder=[[imageEditorView sharedInstance] selectedLayer];
    void (^shadeBlock)(colorPopupToolView*)=^(colorPopupToolView *view){
        [view addShadeGradientToSlider];
        CGFloat hue;
        CGFloat alpha;
        [[UIColor colorWithCGColor:[view.responder color]] getHue:nil saturation:nil brightness:&hue alpha:&alpha];
        hue=1.0f-hue;
        if(alpha!=0)
        {
            [noColorButton.layer setBackgroundColor:[view.responder color]];
            [view.slider setValue:hue];
        }
        else
        {
            [view.slider setValue:0.0f];
        }
    };
    void (^colorBlock)(colorPopupToolView*)=^(colorPopupToolView *view){
        [view addColorGradientToSlider];
        CGFloat hue;
        CGFloat alpha;
        [[UIColor colorWithCGColor:[view.responder color]] getHue:&hue saturation:nil brightness:nil alpha:&alpha];
        if(alpha!=0)
        {
            [noColorButton.layer setBackgroundColor:[view.responder color]];
            [view.slider setValue:hue];
        }
        else
        {
            [view.slider setValue:0.0f];
        }
        
    };
    switch (type) {
        case LTpopupBorderColorTool:{
            self.responder=[[imageEditorView sharedInstance] borderLayer];
            colorBlock(self);
            break;}
        case LTpopupBorderShadeTool:{
            self.responder=[[imageEditorView sharedInstance] borderLayer];
            shadeBlock(self);
            break;
        }
        case LTpopupBodyTextColorTool:{
            self.responder=[[imageEditorView sharedInstance] bodyLayer];
            colorBlock(self);
            break;
        }
        case LTpopupTitleTextColorTool:{
            self.responder=[[imageEditorView sharedInstance] titleLayer];
            colorBlock(self);
            break;
        }
        case LTpopupTitleShadeTool:{
            self.responder=[[imageEditorView sharedInstance] titleLayer];
            shadeBlock(self);
            break;
        }
        case LTpopupBodyShadeTool:{
            self.responder=[[imageEditorView sharedInstance] bodyLayer];
            shadeBlock(self);
            break;
        }
        default:{
            break;}
    }
}

-(IBAction)sliderChanged:(UISlider*)slider
{
    UIColor *current=[UIColor colorWithCGColor:[self.responder color]];
    CGFloat sat;
    CGFloat bright;
    CGFloat alph;
    CGFloat hue;
    [current getHue:&hue saturation:&sat brightness:&bright alpha:&alph];
    
    switch(self.type)
    {
        case LTpopupBorderColorTool:
        case LTpopupBodyTextColorTool:
        case LTpopupTitleTextColorTool:
        {
            if([current isEqual:[UIColor clearColor]])
            {
                bright=1.0f;
                sat=1.0f;
            }
            else if(sat==0)
            {
                sat=1.0f;
            }
            CGColorRef col=[UIColor colorWithHue:5.0f/6.0f*[slider value] saturation:sat brightness:bright alpha:1.0f].CGColor;
            [self.responder colorDidChangeTo:col];
            [noColorButton.layer setBackgroundColor:col];
            break;
        }
        case LTpopupBorderShadeTool:
        case LTpopupBodyShadeTool:
        case LTpopupTitleShadeTool:
        {
            CGColorRef col;
            if([current isEqual:[UIColor clearColor]]||(sat==0&&hue==0))
            {
                bright=1.0f;
                sat=0.0f;
                col=[UIColor colorWithWhite:1.0f-1.0f*[slider value] alpha:1.0f].CGColor;
                CGFloat hue, alpha, brightness, sat;
                [[UIColor colorWithWhite:1.0f-1.0f*[slider value] alpha:1.0f] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
                //NSLog(@"%f, %f, %f, %f",hue,alpha,brightness,sat);
                
            }
            else
            {
                sat=1.0f;
                col=[UIColor colorWithHue:hue saturation:sat brightness:1.0f-1.0f*[slider value] alpha:1.0f].CGColor;
            }
            [self.responder colorDidChangeTo:col];
            [noColorButton.layer setBackgroundColor:col];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
