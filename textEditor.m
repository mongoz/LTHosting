//
//  textEditor.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textEditor.h"

@interface textEditor(){
    UITextView *textField;
}

@end

@implementation textEditor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self=[super initWithEffect:blur];
    textField=[[UITextView alloc] init];
    textField.backgroundColor=[UIColor clearColor];
    textField.delegate=self;
    textField.textColor=[UIColor whiteColor];
    
    [self addSubview:textField];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.delegate=self;
    [textField addGestureRecognizer:tap];
    //textField.autocorrectionType=UITextAutocorrectionTypeNo;
    
    [self registerForKeyboardNotifications];
    
    return self;
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    [textField setFrame:CGRectMake(0, 0, keyboardFrameBeginRect.size.width, self.bounds.size.height-keyboardFrameBeginRect.size.height)];
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    [textField setFrame:self.bounds];
}

-(IBAction)viewTapped:(id)sender
{
    [self dismiss];
}

-(void)dismiss
{
    [self endEditing:YES];
    if(_delegate!=nil)
    {
        [_delegate textEditor:self finishedEditingWithResult:self.attributedText];
    }
    [UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha=0.0f;
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [textField setFrame:self.bounds];
}

-(NSAttributedString*)attributedText
{
    return textField.attributedText;
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [textField setAttributedText:attributedText];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

-(BOOL)becomeFirstResponder
{
    return [textField becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return [textField canBecomeFirstResponder];
}

-(BOOL)isFirstResponder
{
    return [textField isFirstResponder];
}

-(BOOL)endEditing:(BOOL)end
{
    return [textField endEditing:end];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
