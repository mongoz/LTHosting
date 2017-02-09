//
//  flexibleIlluminatedButton.h
//  
//
//  Created by Cam Feenstra on 2/5/17.
//
//

#import "illuminatedButton.h"

@protocol flexibleIlluminatedSource;

@interface flexibleIlluminatedButton : illuminatedButton

@property (strong, nonatomic) id<flexibleIlluminatedSource> flexibleSource;

-(NSInteger)currentIndex;

-(void)transitionToStateAtIndex:(NSInteger)state;

-(void)transitionToStateAtIndex:(NSInteger)state completion:(void(^)())completion;

@end

@protocol flexibleIlluminatedSource <illuminatedSource>

-(NSInteger)numberOfStatesForFlexibleButton;

-(NSString*)flexibleIlluminatedButton:(flexibleIlluminatedButton*)button titleForIndex:(NSInteger)index;

-(BOOL)isIlluminatedAtTitleWithIndex:(NSInteger)index;


@end
