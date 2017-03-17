//
//  keyboardAccessory.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/9/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "keyboardAccessory.h"

@interface keyboardAccessory(){
    keyboardAccessoryType myType;
}

@property (strong, nonatomic) void(^frameChangeBlock)(keyboardAccessory *me);
@end

@implementation keyboardAccessory

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
    self.accessoryType=dismissAccessory;
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_frameChangeBlock!=nil)
    {
        _frameChangeBlock(self);
    }
}

-(id)initWithWidth:(CGFloat)width
{
    self=[self init];
    self.frame=CGRectMake(0, 0, width, 0);
    return self;
}

-(id)initWithType:(keyboardAccessoryType)type width:(CGFloat)width
{
    self=[self initWithWidth:width];
    self.accessoryType=type;
    return self;
}

+(keyboardAccessory*)accessoryWithType:(keyboardAccessoryType)tye width:(CGFloat)width
{
    return [[self alloc] initWithType:tye width:width];
}

-(keyboardAccessoryType)accessoryType
{
    return myType;
}

-(void)setAccessoryType:(keyboardAccessoryType)accessoryType
{
    myType=accessoryType;
    [self nullBlocks];
    [self configureToType:self.accessoryType];
}

-(void)nullBlocks
{
    _dismissBlock=nil;
    _frameChangeBlock=nil;
}

-(void)configureToType:(keyboardAccessoryType)type
{
    switch(type)
    {
        case dismissAccessory:
            [self configureToDismissAccessory];
            break;
    }
}

//Methods for dismiss accessory

-(void)configureToDismissAccessory
{
    self.backgroundColor=[UIColor whiteColor];
    CGFloat topHeight=1.0f;
    UIButton *accessoryButton=[[UIButton alloc] init];
    [accessoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [accessoryButton setTitle:@"Done" forState:UIControlStateNormal];
    accessoryButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    accessoryButton.titleLabel.font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    CGFloat height=self.frame.size.height;
    CGFloat margin=2.0f;
    height-=margin*2;
    height-=topHeight;
    CGFloat width=height*1.618;
    accessoryButton.frame=CGRectMake(self.frame.size.width-margin-width, margin+topHeight, width, height);
    [accessoryButton addTarget:self action:@selector(dismissAccessoryTouchDown:) forControlEvents:UIControlEventTouchDown];
    [accessoryButton addTarget:self action:@selector(dismissAccessoryTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryButton addTarget:self action:@selector(dismissAccessoryTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [accessoryButton addTarget:self action:@selector(dismissAccessoryTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessoryButton];
    UIView *top=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, topHeight)];
    top.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:top];
    _frameChangeBlock=^(keyboardAccessory *acc){
        //[accessoryButton setFrame:acc.bounds];
    };
}

-(void)dismissAccessoryTouchDown:(UIButton*)accessoryButton
{
    [accessoryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

-(void)dismissAccessoryTouchUp:(UIButton*)accessoryButton
{
    [accessoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)dismissAccessoryTouchUpInside:(UIButton*)accessoryButton
{
    if(self.dismissBlock!=nil)
    {
        self.dismissBlock(self);
    }
}

-(void)reset
{
    for(UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
}



@end
