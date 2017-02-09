//
//  aboutOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "aboutOptionView.h"
#import "stackView.h"

@interface aboutOptionView(){
    UITextView *tView;
}
@end

@implementation aboutOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    [self configureAccessoryView];
    return self;
}

-(BOOL)hasAccessoryView
{
    return YES;
}

-(void)configureAccessoryView
{
    self.accessoryView=[[stackView alloc] initWithFrame:CGRectMake(self.barView.frame.origin.x, self.barView.frame.size.height+self.barView.frame.origin.y, self.barView.frame.size.width, self.bounds.size.height-self.barView.frame.size.height)];
    tView=[[UITextView alloc] initWithFrame:self.accessoryView.bounds];
    [self.accessoryView addSubview:tView];
    [tView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [tView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    tView.inputAccessoryView=self.inputAccessoryView;
    [self.accessoryView.layer setShadowColor:self.barView.layer.shadowColor];
    [self.accessoryView.layer setShadowRadius:self.barView.layer.shadowRadius];
    [self.accessoryView.layer setShadowOpacity:self.barView.layer.shadowOpacity];
    [self addArrangedSubview:self.accessoryView];
    [self bringSubviewToFront:self.barView];
    self.accessoryView.hidden=YES;
    for(UIView *v in self.barView.subviews)
    {
        if(v.class==[UITextField class])
        {
            [v setUserInteractionEnabled:NO];
            [(UITextField*)v setPlaceholder:@"Add About..."];
        }
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    tap.numberOfTapsRequired=2;
    tap.delegate=self;
    [tView addGestureRecognizer:tap];
    self.accessoryView.layer.masksToBounds=YES;
}

-(IBAction)textTapped:(UITapGestureRecognizer*)tap
{
    if([tView isFirstResponder])
    {
        [self tapBar];
    }
}

-(void)tapBar
{
    BOOL shouldBecome=NO;
    if(self.isAccessoryViewShowing)
    {
        for(UIView *v in self.barView.subviews)
        {
            if(v.class==[UITextField class])
            {
                [(UITextField*)v setText:tView.text];
            }
        }
    }
    else
    {
        shouldBecome=YES;
    }
    [super tapBar];
    if([tView isFirstResponder])
    {
        [tView endEditing:YES];
        if([tView canResignFirstResponder])
        {
            [tView resignFirstResponder];
        }
    }
    else if(shouldBecome)
    {
        [tView becomeFirstResponder];
    }
}

-(void)detailEditingWillEnd
{
    [[event sharedInstance] setAbout:tView.text];
}


@end
