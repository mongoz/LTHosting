//
//  eventPageHeaderView.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/6/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageHeaderView.h"

@interface eventPageHeaderView(){
    user *myUser;
    CGFloat myWidth;
    UIImageView *imageView;
    UILabel *label;
}

@end

@implementation eventPageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithUser:(user *)user width:(CGFloat)width
{
    self=[super init];
    myWidth=width;
    self.poster=user;
    return self;
}

+(eventPageHeaderView*)headerViewForUser:(user *)user withWidth:(CGFloat)width
{
    eventPageHeaderView *view=[[self alloc] initWithUser:user width:width];
    return view;
}

-(void)configure
{
    CGFloat bottomHeight=1.0f;
    [self reset];
    UIFont *nameFont=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    CGFloat myheight=nameFont.lineHeight*2.0f;
    CGFloat margin=8.0f;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, myWidth, myheight+margin*2+bottomHeight)];
    if(myUser==nil)
    {
        return;
    }
    imageView=[[UIImageView alloc] initWithImage:myUser.profileImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setFrame:CGRectMake(margin, margin, myheight, myheight)];
    [imageView.layer setCornerRadius:imageView.frame.size.height/2];
    [imageView.layer setMasksToBounds:YES];
    [self addSubview:imageView];
    
    label=[[UILabel alloc] init];
    [label setAttributedText:[[NSAttributedString alloc] initWithString:myUser.name attributes:@{NSFontAttributeName:nameFont}]];
    [label setFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+margin*2, imageView.frame.origin.y, self.frame.size.width-margin*4-imageView.frame.size.width, imageView.frame.size.height)];
    [self addSubview:label];
    
    UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-bottomHeight, self.frame.size.width, bottomHeight)];
    [bottom setBackgroundColor:[UIColor blackColor]];
    [self addSubview:bottom];
}

-(void)reset
{
    for(UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
}

-(void)setPoster:(user *)poster
{
    myUser=poster;
    [self configure];
}

-(user*)poster
{
    return myUser;
}

@end
