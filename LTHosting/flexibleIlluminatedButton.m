//
//  flexibleIlluminatedButton.m
//  
//
//  Created by Cam Feenstra on 2/5/17.
//
//

#import "flexibleIlluminatedButton.h"

@interface flexibleIlluminatedButton(){
    NSInteger currentIndex;
    
    NSInteger numStates;
    
}
@end

@implementation flexibleIlluminatedButton

@dynamic source;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

NSTimeInterval animationTime=.15;

-(void)setSource:(id<illuminatedSource>)source
{
    [super setSource:nil];
}

-(id)init
{
    self=[super init];
    currentIndex=0;
    self.flexibleSource=nil;
    self.source=nil;
    return self;
}

-(void)setFlexibleSource:(id<flexibleIlluminatedSource>)flexibleSource
{
    _flexibleSource=flexibleSource;
    [self reloadData];
}

-(NSInteger)currentIndex
{
    return currentIndex;
}

-(void)changeState
{
    currentIndex=(currentIndex+1)%numStates;
    [self transitionToStateAtIndex:currentIndex];
}

-(void)transitionToStateAtIndex:(NSInteger)index completion:(void (^)())completion
{
    if(self.flexibleSource!=nil)
    {
        BOOL isIllum=[self.flexibleSource isIlluminatedAtTitleWithIndex:index];
        if(self.responder!=nil&&[self.responder respondsToSelector:@selector(illuminatedButton:stateWillChangeTo:)])
        {
            [self.responder illuminatedButton:self stateWillChangeTo:isIllum];
        }
        if(isIllum)
        {
            [UIView animateWithDuration:animationTime animations:^{
                [self.titleLabel setTextColor:self.onTextColor];
                [self setTitleColor:self.onTextColor forState:UIControlStateNormal];
                [self.layer setBackgroundColor:self.illuminationColor.CGColor];
                [self setTitle:[self.flexibleSource flexibleIlluminatedButton:self titleForIndex:index] forState:UIControlStateNormal];
                if(self.titleLabel.attributedText.size.width>self.titleLabel.frame.size.width*.9)
                {
                    [self.titleLabel sizeToFit];
                }
            } completion:^(BOOL finished){
                self.illuminated=YES;
                if(completion!=nil)
                {
                    completion();
                }
            }];
        }
        else
        {
            [UIView animateWithDuration:animationTime animations:^{
                [self.titleLabel setTextColor:self.offTextColor];
                [self setTitleColor:self.offTextColor forState:UIControlStateNormal];
                [self.layer setBackgroundColor:self.offColor.CGColor];
                if(self.flexibleSource!=nil)
                {
                    [self setTitle:[self.flexibleSource flexibleIlluminatedButton:self titleForIndex:index] forState:UIControlStateNormal];
                    [self.titleLabel sizeToFit];
                }
            } completion:^(BOOL finished){
                self.illuminated=NO;
                if(completion!=nil)
                {
                    completion();
                }
            }];
        }
    }
}

-(void)transitionToStateAtIndex:(NSInteger)state
{
    [self transitionToStateAtIndex:state completion:nil];
}

-(void)reloadData
{
    numStates=[_flexibleSource numberOfStatesForFlexibleButton];
    [self transitionToStateAtIndex:currentIndex];
}

@end
