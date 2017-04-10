//
//  LTTextViewImageContainer.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTTextViewImageContainer.h"

@interface LTTextViewImageContainer(){
    UIImageView *imageView;
    UIButton *xButton;
}

@end

@implementation LTTextViewImageContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self=[super init];
    imageView=[[UIImageView alloc] init];
    imageView.layer.cornerRadius=8.0f;
    imageView.layer.masksToBounds=YES;
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    xButton=[[UIButton alloc] init];
    xButton.frame=CGRectMake(0, 0, 32, 32);
    xButton.layer.cornerRadius=xButton.frame.size.height/2;
    xButton.layer.masksToBounds=YES;
    xButton.backgroundColor=[UIColor blackColor];
    [xButton setTitle:@"X" forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(xPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xButton];
    return self;
}

-(void)xPressed:(UIButton*)x{
    if(_delegate!=nil&&[_delegate respondsToSelector:@selector(removeImageContainer:)]){
        [_delegate removeImageContainer:self];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    imageView.frame=self.bounds;
    xButton.center=CGPointMake(xButton.frame.size.width/2, xButton.frame.size.height/2);
    imageView.bounds=CGRectMake(0,0,imageView.frame.size.width-xButton.frame.size.width, imageView.frame.size.height-xButton.frame.size.height);
}

-(void)setImage:(UIImage *)image{
    imageView.image=image;
}

-(UIImage*)image{
    return imageView.image;
}

@end
