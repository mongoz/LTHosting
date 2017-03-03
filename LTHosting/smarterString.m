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
    NSArray<NSAttributedString*>* (^attributedArray)(NSArray<NSString*>*, NSString *)=^NSArray<NSAttributedString*>*(NSArray<NSString*>* original, NSString *sep){
        NSMutableArray<NSAttributedString*> *attributedWords=[[NSMutableArray alloc] init];
        NSInteger start=0;
        for(NSInteger i=0; i<original.count; i++)
        {
            NSInteger extra=sep.length;
            if(i==original.count-1)
            {
                extra=0;
            }
            [attributedWords addObject:[self attributedSubstringFromRange:NSMakeRange(start, original[i].length+extra)]];
            start+=original[i].length+extra;
        }
        return attributedWords;
    };
    NSArray *comps=[self.string componentsSeparatedByString:@"\n"];
    if(comps.count>1)
    {
        NSInteger totalLines=0;
        for(NSAttributedString *attstr in attributedArray(comps, @"\n"))
        {
            if(attstr.length>1)
            {
                NSInteger minus=0;
                if([[attstr.string substringFromIndex:attstr.length-1] isEqualToString:@"\n"])
                {
                    minus=1;
                }
                totalLines+=[[attstr attributedSubstringFromRange:NSMakeRange(0, attstr.length-minus)] numberOfLinesRequiredForLineWidth:lineWidth];
            }
            else
            {
                totalLines++;
            }
        }
        return totalLines;
    }
    else
    {
        NSMutableArray<NSString*> *words=[NSMutableArray arrayWithArray:[self.string componentsSeparatedByString:@" "]];
        NSMutableArray<NSAttributedString*> *attributedWords=[NSMutableArray arrayWithArray:attributedArray(words, @" ")];
        NSMutableAttributedString *line=[[NSMutableAttributedString alloc] init];
        NSInteger lines=1;
        NSInteger index=0;
        NSInteger onThisLine=0;
        if(attributedWords.count==1)
        {
            lines=ceilf(attributedWords.firstObject.size.width/lineWidth);
        }
        else
        {
            while(index<attributedWords.count)
            {
                [line appendAttributedString:attributedWords[index]];
                onThisLine++;
                if(line.size.width>lineWidth)
                {
                    if(onThisLine>1)
                    {
                        lines++;
                    }
                    onThisLine=1;
                    line=[[NSMutableAttributedString alloc] initWithAttributedString:attributedWords[index]];
                    if(line.size.width>lineWidth)
                    {
                        lines+=ceilf(line.size.width/lineWidth);
                        line=[[NSMutableAttributedString alloc] init];
                        onThisLine=0;
                    }
                }
                index++;
            }
        }
        return lines;
    }
}

@end

@implementation NSString(smart)

-(NSInteger)numberOfOccurancesOfString:(NSString *)string
{
    NSInteger currentIndex=0;
    NSInteger count=0;
    while(currentIndex<self.length)
    {
        NSString *sub=[self substringFromIndex:currentIndex];
        if(![sub containsString:string])
        {
            break;
        }
        else
        {
            NSRange stringRange=[sub rangeOfString:string];
            currentIndex=stringRange.location+stringRange.length;
            count++;
        }
    }
    return count;
}

@end
