//
//  colorPopupToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "colorPopupToolView.h"

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
    self=[super initWithFrame:frame];
    [self.slider setContinuous:YES];
    [self.slider setMinimumValue:0];
    [self.slider setMaximumValue:1];
    [self addGradientToSlider];
    return self;
}

-(void)addGradientToSlider
{
    //UIView *view=[self.slider.subviews objectAtIndex:0];
    //NSLog(@"view class: %@",view.class);
    //UIImageView *before=[view.subviews objectAtIndex:0];
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    // Create colors using hues in +5 increments
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue<=360; hue += 5) {
        
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * hue / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [gradientLayer setStartPoint:CGPointMake(0.0f, 0.5f)];
    [gradientLayer setEndPoint:CGPointMake(1.0f, 0.5f)];
    
    CGFloat gradientHeight=24;
    CGRect gradientFrame=[self.slider trackRectForBounds:self.slider.bounds];
    gradientFrame=CGRectMake(0, self.slider.bounds.size.height/2-gradientHeight/2, gradientFrame.size.width, gradientHeight);
    [gradientLayer setFrame:gradientFrame];
    [gradientLayer setCornerRadius:gradientHeight/2];
    
    UIImage *layerImage=[UIImage imageForLayer:gradientLayer];
    layerImage=[layerImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [self.slider setMaximumTrackImage:layerImage forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:layerImage forState:UIControlStateNormal];
}

-(void)configureWithToolType:(popupType)type
{
    self.responder=[[imageEditorView sharedInstance] selectedLayer];
    switch (type) {
        case LTpopupColorTool:{
            [self addGradientToSlider];
            CGFloat hue;
            [[UIColor colorWithCGColor:[self.responder color]] getHue:&hue saturation:nil brightness:nil alpha:nil];
            [self.slider setValue:hue];
            break;}
            
        default:{
            break;}
    }
}

-(IBAction)sliderChanged:(UISlider*)slider
{
    [self.responder colorDidChangeTo:[UIColor colorWithHue:1.0f*[slider value] saturation:1.0f brightness:1.0f alpha:1.0f].CGColor];
}

@end
