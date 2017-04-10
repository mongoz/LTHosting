//
//  profileButton.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "profileButton.h"

@interface profileButton(){
    user *myUser;
    CGFloat touchUpScale;
}

@end

@implementation profileButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self=[super init];
    myUser=nil;
    self.contentMode=UIViewContentModeScaleAspectFill;
    [self setClipsToBounds:YES];
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    self.animationDuration=.15;
    self.touchScale=.9;
    self.resizesOnTouch=YES;
    return self;
}

-(id)initWithUser:(user *)user{
    self=[self init];
    self.user=user;
    return self;
}

-(id)initWithFrame:(CGRect)frame user:(user *)user{
    self=[self initWithFrame:frame];
    self.user=user;
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.layer.cornerRadius=MIN(self.frame.size.height,self.frame.size.width)/2.0f;
}

-(void)touchDown:(UIButton*)button{
    touchUpScale=1/self.touchScale;
    if(self.resizesOnTouch){
        [self scaleBy:self.touchScale animated:YES completion:nil];
    }
}

-(void)touchUpOutside:(UIButton*)button{
    [self touchUpWithCompletion:nil];
}

-(void)touchUpInside:(UIButton*)button{
    [self touchUpWithCompletion:^{
        [self transition];
    }];
}

-(void)touchUpWithCompletion:(void(^)())completionBlock{
    if(self.resizesOnTouch){
        [self scaleBy:touchUpScale animated:YES completion:completionBlock];
    }
    else{
        if(completionBlock!=nil){
            completionBlock();
        }
    }
}

-(void)transition{
    if(self.transitionController!=nil&&self.user!=nil){
        [self.transitionController transitionToProfileForUser:self.user];
    }
}

-(void)scaleBy:(CGFloat)scale animated:(BOOL)animated completion:(void(^)())completionBlock{
    void (^actionBlock)()=^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:self.animationDuration];
        self.layer.cornerRadius=self.layer.cornerRadius*scale;
        self.frame=CGRectMake(self.frame.origin.x+self.frame.size.width*(1-scale)/2, self.frame.origin.y+self.frame.size.height*(1-scale)/2, self.frame.size.width*scale, self.frame.size.height*scale);
        [CATransaction commit];
    };
    void (^completion)(BOOL)=^(BOOL finished){
        if(completionBlock!=nil){
            completionBlock();
        }
    };
    if(animated){
        [UIView animateWithDuration:self.animationDuration animations:actionBlock completion:completion];
    }
    else{
        actionBlock();
        completion(YES);
    }
}

-(user*)user{
    return myUser;
}

-(void)setUser:(user *)newuser{
    myUser=newuser;
    if(myUser!=nil){
        [self setBackgroundImage:myUser.profileImage forState:UIControlStateNormal];
    }
}

@end
