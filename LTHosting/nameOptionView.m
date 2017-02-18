//
//  nameOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "nameOptionView.h"

@interface nameOptionView(){
    UITextField *field;
}
@end

@implementation nameOptionView

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
    field=nil;
    [self configureBarView];
    return self;
}

-(void)configureBarView
{
    CGFloat margin=8;
    CGRect textFieldRect=CGRectMake(margin, margin, self.barView.frame.size.width-margin*2, self.barView.frame.size.height-margin*2);
    field=[[UITextField alloc] initWithFrame:textFieldRect];
    field.inputAccessoryView=[self inputAccessoryView];
    field.textColor=[UIColor flatTealColorDark];
    [field setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [field setPlaceholder:@"Add Name..."];
    field.attributedPlaceholder=[[NSAttributedString alloc] initWithString:field.placeholder attributes:[NSDictionary dictionaryWithObject:[[UIColor flatTealColorDark] colorWithAlphaComponent:.75] forKey:NSForegroundColorAttributeName]];
    [self.barView addSubview:field];
    [field setReturnKeyType:UIReturnKeyDone];
    [field addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
}

-(IBAction)donePressed:(UITextField*)tField
{
    [tField endEditing:YES];
    if(self.isAccessoryViewShowing)
    {
        [self tapBar];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)detailEditingWillEnd
{
    [[event sharedInstance] setName:field.text];
}

@end
