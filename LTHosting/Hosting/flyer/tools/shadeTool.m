//
//  shadeTool.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "shadeTool.h"
#import "borderEditingLayer.h"

@implementation shadeTool

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSArray<id>*)colorArray
{
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 360; hue>=0; hue -= 5) {
        
        UIColor *color;
        color = [UIColor colorWithWhite:hue/360.0f alpha:1.0f];
        [colors addObject:(id)[color CGColor]];
    }
    return colors;
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
    if(self.targetLayer.mask==nil&&self.targetLayer.class==[borderEditingLayer class])
    {
        [self.targetLayer setColor:[UIColor colorWithWhite:1.0f-slider.value alpha:1.0f]];
    }
    else
    {
        [self.targetLayer setColor:[UIColor colorWithHue:hue saturation:saturation brightness:1.0f-slider.value alpha:1]];
    }
    [self updateClearColor];
}

-(CGFloat)currentValue
{
    CGFloat hue;
    CGFloat brightness;
    CGFloat saturation;
    CGFloat alpha;
    [[self.targetLayer color] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if(saturation==0)
    {
        return 0;
    }
    return 1.0f-brightness;
}

@end
