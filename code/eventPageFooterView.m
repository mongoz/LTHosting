//
//  eventPageFooterView.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageFooterView.h"
#import <ChameleonFramework/Chameleon.h>

@interface eventPageFooterView(){
    UIButton *accept;
    UIButton *deny;
    CGFloat margin;
}

@end

@implementation eventPageFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self=[super init];
    margin=16.0f;
    accept=[[UIButton alloc] init];
    accept.backgroundColor=[UIColor flatGreenColor];
    [accept addTarget:self action:@selector(acceptPressed:) forControlEvents:UIControlEventTouchUpInside];
    deny=[[UIButton alloc] init];
    deny.backgroundColor=[UIColor flatRedColor];
    [deny addTarget:self action:@selector(denyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accept];
    [self addSubview:deny];
    self.layer.shouldRasterize=YES;
    self.layer.shadowColor=[UIColor whiteColor].CGColor;
    self.layer.shadowOpacity=1.0f;
    self.layer.shadowRadius=0.0f;
    self.layer.shadowOffset=CGSizeZero;
    void (^addButtonShadow)(UIView*)=^(UIView *b){
        b.layer.shadowRadius=8.0f;
        b.layer.shadowColor=[UIColor whiteColor].CGColor;
        b.layer.shadowOffset=CGSizeZero;
        b.layer.shadowOpacity=1.0f;
    };
    addButtonShadow(accept);
    addButtonShadow(deny);
    self.clipsToBounds=NO;
    return self;
}

-(void)acceptPressed:(UIButton*)but{
    NSLog(@"accept");
}

-(void)denyPressed:(UIButton*)but{
    NSLog(@"deny");
}

-(float(^)(float))g:(float)k range:(float)range{
    return ^float(float x){
        return 1-powf(x/range,k);
    };
}

-(UIImage*)createTopShadowWithSize:(CGSize)size{
    CAGradientLayer *gradient=[[CAGradientLayer alloc] init];
    gradient.frame=CGRectMake(0, 0, size.width, size.height);
    gradient.startPoint=CGPointMake(.5, 1);
    gradient.endPoint=CGPointMake(.5, 0.2f);
    NSMutableArray *colors=[[NSMutableArray alloc] init];
    NSInteger numColors=300;
    float (^f)(float x)=[self g:.75f range:numColors];
    for(NSInteger i=0; i<numColors; i++)
    {
        [colors addObject:(id)[UIColor colorWithWhite:1.0f alpha:f((float)i)].CGColor];
    }
    [gradient setColors:colors];
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [gradient renderInContext:ctx];
    UIImage *im=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return im;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    if(CGRectContainsPoint(accept.frame, point)||CGRectContainsPoint(deny.frame, point)){
        return YES;
    }
    return NO;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    void (^setButtonSize)(UIButton*)=^(UIButton *b){
        b.frame=CGRectMake(0, 0, self.frame.size.height-margin*2, self.frame.size.height-margin*2);
        b.layer.cornerRadius=b.frame.size.height/2;
    };
    self.layer.contents=(id)[self createTopShadowWithSize:self.frame.size].CGImage;
    self.layer.contentsGravity=kCAGravityBottom;
    setButtonSize(accept);
    setButtonSize(deny);
    accept.center=CGPointMake(accept.frame.size.width/2+margin, accept.frame.size.height/2+margin);
    deny.center=CGPointMake(self.frame.size.width-(deny.frame.size.width/2+margin), deny.frame.size.height/2+margin);
}

-(id)initWithWidth:(CGFloat)width{
    self=[self init];
    self.frame=CGRectMake(0, 0, width, 100.0f);
    return self;
}

+(eventPageFooterView*)footerViewWithWidth:(CGFloat)width{
    return [[self alloc] initWithWidth:width];
}

@end
