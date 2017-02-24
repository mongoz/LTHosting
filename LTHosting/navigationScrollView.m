//
//  navigationScrollView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "navigationScrollView.h"

@implementation navigationScrollView

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
    for(UIGestureRecognizer *rec in self.gestureRecognizers)
    {
        rec.delegate=self;
    }
    return self;
}

-(BOOL)shouldSwipeInView
{
    return YES;
}

@end
