//
//  nameOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "nameOptionView.h"
#import "keyboardAccessory.h"

@interface nameOptionView(){
    UITextField *field;
    UIImageView *imageView;
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
    imageView=[[UIImageView alloc] init];
    [self configureBarView];
    return self;
}

-(void)configureBarView
{
    CGFloat margin=8;
    CGFloat height=self.barView.frame.size.height-margin*2;
    CGRect imageViewRect=CGRectMake(margin, margin, height, height);
    CGRect textFieldRect=CGRectMake(imageViewRect.origin.x+imageViewRect.size.width+margin, margin, self.barView.frame.size.width-height-margin*3, height);
    field=[[UITextField alloc] initWithFrame:textFieldRect];
    void (^scaleBy)(UIView *v, CGFloat scale)=^(UIView *v, CGFloat scale){
        CGPoint center=v.center;
        [v setBounds:CGRectMake(0, 0, v.frame.size.width*scale, v.frame.size.height*scale)];
        v.center=center;
    };
    imageView.frame=imageViewRect;
    scaleBy(imageView,.75f);
    keyboardAccessory *acc=[keyboardAccessory accessoryWithType:dismissAccessory width:self.frame.size.width];
    acc.dismissBlock=^(keyboardAccessory *accessory){
        [self donePressed:field];
    };
    field.inputAccessoryView=acc;
    field.autocorrectionType=UITextAutocorrectionTypeNo;
    field.textColor=[UIColor blackColor];
    [field setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [field setPlaceholder:@"Add Name..."];
    field.attributedPlaceholder=[[NSAttributedString alloc] initWithString:field.placeholder attributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName]];
    [self.barView addSubview:field];
    [self.barView addSubview:imageView];
    [field setReturnKeyType:UIReturnKeyDone];
    [field addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
}

-(void)setOptionImage:(UIImage *)optionImage{
    [super setOptionImage:optionImage];
    imageView.image=self.optionImage;
}

-(IBAction)donePressed:(UITextField*)tField
{
    [tField endEditing:YES];
    if(self.isAccessoryViewShowing)
    {
        [self tapBar];
    }
}

-(void)barTouched{
    [super barTouched];
    if(!self.hasAccessoryView){
        /*if(field.isFirstResponder){
            [field endEditing:YES];
        }
        else{
        }*/
        [field becomeFirstResponder];
    }
    else{
        if(self.isAccessoryViewShowing){
            [field becomeFirstResponder];
        }
        else{
            [field endEditing:YES];
        }
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

-(NSString*)optionName
{
    return @"Name";
}

-(BOOL)isComplete
{
    return field.text.length>0;
}

@end
