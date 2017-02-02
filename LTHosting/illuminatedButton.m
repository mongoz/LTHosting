//
//  illuminatedButton.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/1/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "illuminatedButton.h"

@interface illuminatedButton(){
    
}
@end

@implementation illuminatedButton

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
    [self configure];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self configure];
    [self setFrame:frame];
    return self;
}

-(void)configure
{
    _illuminationColor=[UIColor blackColor];
    _offColor=[UIColor clearColor];
    _illuminated=NO;
    _onTextColor=[UIColor whiteColor];
    _offTextColor=[UIColor blackColor];
    [self addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.layer setMasksToBounds:YES];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self setTitleColor:_offTextColor forState:UIControlStateNormal];
    [self.layer setBackgroundColor:_offColor.CGColor];
    [self.layer setBorderWidth:2];
    [self.layer setBorderColor:_illuminationColor.CGColor];
    _responder=nil;
    _source=nil;
}



-(void)sendMessageToResponder:(void (^)(id<illuminatedButtonResponder> responder))block
{
    if(_responder!=nil)
    {
        block(_responder);
    }
}

-(IBAction)touchDownInside:(illuminatedButton*)button
{
    
}

-(IBAction)touchUpInside:(illuminatedButton*)button
{
    [self changeState];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius=frame.size.height/2.0f;
}

-(void)changeToIlluminated
{
    [self.titleLabel setTextColor:_onTextColor];
    [self setTitleColor:_onTextColor forState:UIControlStateNormal];
    [self.layer setBackgroundColor:_illuminationColor.CGColor];
    _illuminated=YES;
    if(_source!=nil)
    {
        [self setTitle:[_source onTitle] forState:UIControlStateNormal];
    }
}

-(void)changeFromIlluminated
{
    [self.titleLabel setTextColor:_offTextColor];
    [self setTitleColor:_offTextColor forState:UIControlStateNormal];
    [self.layer setBackgroundColor:_offColor.CGColor];
    _illuminated=NO;
    if(_source!=nil)
    {
        [self setTitle:[_source offTitle] forState:UIControlStateNormal];
    }
}

-(void)changeState
{
    [self sendMessageToResponder:^(id<illuminatedButtonResponder> resp){
        [resp illuminatedButton:self stateWillChangeTo:!_illuminated];
    }];
    void (^animationBlock)();
    if(_illuminated)
    {
        animationBlock=^{
            [self changeFromIlluminated];
        };
    }
    else
    {
        animationBlock=^{
            [self changeToIlluminated];
        };
    }
    [UIView animateWithDuration:.25 animations:^{
        animationBlock();
    } completion:^(BOOL finished){
        [self sendMessageToResponder:^(id<illuminatedButtonResponder> resp){
            [resp illuminatedButton:self stateDidChangeTo:_illuminated];
        }];
    }];
}

-(void)reloadData
{
    if(_illuminated)
    {
        [self setTitle:[_source onTitle] forState:UIControlStateNormal];
    }
    else
    {
        [self setTitle:[_source offTitle] forState:UIControlStateNormal];
    }
}

@end
