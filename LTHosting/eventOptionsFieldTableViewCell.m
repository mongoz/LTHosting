//
//  eventOptionsFieldTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventOptionsFieldTableViewCell.h"

@interface eventOptionsFieldTableViewCell(){
    BOOL isTouching;
    BOOL isAddress;
}
@end

@implementation eventOptionsFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    isTouching=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(eventOptionTableViewCell*)cellForOption:(NSString*)option table:(UITableView *)table withParent:(eventDetailViewController *)parent
{
    eventOptionsFieldTableViewCell *new=[table dequeueReusableCellWithIdentifier:@"fieldOptionCell"];
    new.option=option;
    NSString *parentOption=(NSString*)[parent.creation objectForOption:option];
    if([parentOption isEqualToString:@"Add"])
    {
        parentOption=[NSString stringWithFormat:@"%@...",option];
    }
    new.textBox.text=parentOption;
    if([option isEqualToString:@"Name"]||[option isEqualToString:@"Address"])
    {
        [new setFrame:CGRectMake(new.frame.origin.x, new.frame.origin.y, new.frame.size.width, 60)];
        [new.textBox.textContainer setMaximumNumberOfLines:1];
        [new.textBox.textContainer setLineBreakMode:NSLineBreakByTruncatingHead];
        
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    [tap addTarget:new action:@selector(textViewTapped:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    tap.delegate=new;
    [new.textBox addGestureRecognizer:tap];
    new.placeholderText=[NSString stringWithFormat:@"%@...",option];
    new.textBox.delegate=new;
    [new.textBox setFont:[UIFont systemFontOfSize:18]];
    [new setSelectionStyle:UITableViewCellSelectionStyleNone];
    [new addInfoRecognizers];
    [new setSeparatorInset:UIEdgeInsetsZero];
    
    [new.textBox setReturnKeyType:UIReturnKeyDone];
    return new;
}

-(void)addInfoRecognizers
{
    if([self.option isEqualToString:@"Address"])
    {
        //[_textBox setDataDetectorTypes:UIDataDetectorTypeAddress];
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat yborder=8;
    CGFloat xborder=16;
    [_textBox setFrame:CGRectMake(xborder, yborder, frame.size.width-(xborder*2), frame.size.height-(yborder*2))];
}

//UITextViewDelegate protocol methods
-(void)textViewTapped:(UITapGestureRecognizer*)gesture
{
    [_textBox setEditable:YES];
    isTouching=YES;
    //[self textViewDidBeginEditing:_textBox];
    [self.parent textViewTouched:_textBox option:self.option];
    if([_textBox canBecomeFirstResponder])
    {
        [_textBox becomeFirstResponder];
    }
}

-(void)incrementCursor:(BOOL)forward
{
    NSRange selected=[_textBox selectedRange];
    NSInteger increment=1;
    if(!forward)
    {
        increment=-1;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_textBox setSelectedRange:NSMakeRange(selected.location+increment, selected.length)];
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(![textView.text isEqualToString:@""])
    {
        NSString *currentText=textView.text;
        currentText=[currentText substringFromIndex:currentText.length-1];
        if([currentText isEqualToString:@"\n"])
        {
            [textView setText:[textView.text substringToIndex:textView.text.length-1]];
            [self textViewDidEndEditing:_textBox];
        }
    }
    if(isAddress)
    {
        [self.parent addressDidChange:textView.text];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!isTouching)
    {
        isTouching=YES;
        [self.parent textViewTouched:_textBox option:self.option];
        if([_textBox canBecomeFirstResponder])
        {
            [_textBox becomeFirstResponder];
        }
    }
    if([textView.text isEqualToString:_placeholderText])
    {
        [textView setText:@""];
    }
    //[self.parent textViewTouched:self.option];
    
    if([self.option isEqualToString:@"Address"])
    {
        isAddress=YES;
    }
    else
    {
        isAddress=NO;
    }
    if(isAddress)
    {
        [self.parent addressDidBeginEditing:textView.text];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        [textView setText:_placeholderText];
    }
    isTouching=NO;
    [textView setEditable:NO];
    if(isAddress)
    {
        [self.parent addressDidEndEditing:textView.text];
    }
    [self.parent updateOption:self.option withSelection:_textBox.text];
}


-(void)update
{
    [self.parent updateOption:self.option withSelection:_textBox.text];
}

-(void)completeAddress:(NSString *)address
{
    NSBlockOperation *setText=[NSBlockOperation blockOperationWithBlock:^{
        [_textBox setText:address];
    }];
    [setText setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textBox endEditing:YES];
        });
    }];
    [[NSOperationQueue mainQueue] addOperation:setText];
}


@end
