//
//  colorTool.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "colorTool.h"
#import "commonUseFunctions.h"

@interface colorTool(){
    UISlider *mySlider;
}

@end

@implementation colorTool

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
    mySlider=nil;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat margin=24;
    if(frame.size.height>0&&frame.size.width>0)
    {
        if(mySlider==nil)
        {
            mySlider=[[UISlider alloc] initWithFrame:CGRectMake(margin, margin, self.bounds.size.width-margin*2, self.bounds.size.height-margin*2)];
            [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            mySlider.minimumValue=0;
            mySlider.maximumValue=1;
            [self addSubview:mySlider];
        }
        [self addGradientToSlider:mySlider WithColors:[self colorArray]];
    }
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

-(void)addGradientToSlider:(UISlider*)slider WithColors:(NSArray<id>*)colors
{
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [gradientLayer setStartPoint:CGPointMake(0.0f, 0.5f)];
    [gradientLayer setEndPoint:CGPointMake(1.0f, 0.5f)];
    
    CGFloat gradientHeight=24;
    CGRect gradientFrame=[slider trackRectForBounds:slider.bounds];
    gradientFrame=CGRectMake(0, slider.bounds.size.height/2-gradientHeight/2, gradientFrame.size.width, gradientHeight);
    [gradientLayer setFrame:gradientFrame];
    [gradientLayer setCornerRadius:gradientHeight/2];
    [gradientLayer setBorderColor:[UIColor blackColor].CGColor];
    [gradientLayer setBorderWidth:2.0f];
    
    UIImage *layerImage=[UIImage imageForLayer:gradientLayer];
    layerImage=[layerImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [slider setMaximumTrackImage:layerImage forState:UIControlStateNormal];
    [slider setMinimumTrackImage:layerImage forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
}

-(IBAction)sliderValueChanged:(UISlider*)slider
{
    CGFloat hue;
    CGFloat brightness;
    CGFloat saturation;
    CGFloat alpha;
    [[self.targetLayer color] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if(brightness==0)
    {
        brightness=1;
    }
    [self.targetLayer setColor:[UIColor colorWithHue:slider.value*5.0f/6.0f saturation:1 brightness:brightness alpha:1]];
}

@end
