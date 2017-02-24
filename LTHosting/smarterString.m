//
//  class.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/22/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "smarterString.h"

@implementation NSAttributedString (smart)

-(NSInteger)numberOfLinesRequiredForLineWidth:(CGFloat)lineWidth
{
    NSInteger startIndex=0;
    NSInteger currentLength=1;
    NSInteger lines=1;
    BOOL done=NO;
    while(!done)
    {
        if(startIndex+currentLength>self.length)
        {
            done=YES;
        }
        else
        {
            NSAttributedString *sub=[self attributedSubstringFromRange:NSMakeRange(startIndex, currentLength)];
            if(sub.size.width>lineWidth)
            {
                lines++;
                startIndex+=currentLength;
                currentLength=1;
            }
            else
            {
                currentLength++;
            }
        }
        
    }
    return lines;
}

@end
