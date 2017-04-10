//
//  stackLabel.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "stackLabel.h"

@implementation stackLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGSize)intrinsicContentSize
{
    return self.bounds.size;
}

@end
