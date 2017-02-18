//
//  responsiveSlider.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "responsiveSlider.h"

@implementation responsiveSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
