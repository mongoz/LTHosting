//
//  backgroundTintTool.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "backgroundTintTool.h"

@implementation backgroundTintTool

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGFloat)minimumValue
{
    return 0.0f;
}

-(CGFloat)maximumValue
{
    return 1.0f;
}

-(void)sliderValueChanged:(UISlider*)slider
{
    self.targetLayer.opacity=slider.value;
}

-(CGFloat)currentValue
{
    if(self.targetLayer==nil)
    {
        return 0;
    }
    return self.targetLayer.opacity;
}

@end
