//
//  LTTextView.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTTextView.h"

@interface LTTextView(){
    UITextView *textView;
    CGFloat margin;
    NSMutableArray<LTTextViewImageContainer*> *imageContainers;
}

@end

@implementation LTTextView

-(id)init{
    self=[super init];
    textView=[[UITextView alloc] init];
    textView.delegate=self;
    [self addSubview:textView];
    imageContainers=[[NSMutableArray alloc] init];
    margin=8.0f;
    return self;
}

-(UITextView*)textView{
    return textView;
}

-(NSAttributedString*)attributedText
{
    return textView.attributedText;
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    textView.attributedText=attributedText;
}

-(NSString*)text{
    return textView.text;
}

-(void)setText:(NSString *)text{
    textView.text=text;
}

-(UITextAutocorrectionType)autocorrectionType{
    return textView.autocorrectionType;
}

-(void)setAutocorrectionType:(UITextAutocorrectionType)autoCorrectionType{
    textView.autocorrectionType=autoCorrectionType;
}

-(UIFont*)font{
    return textView.font;
}

-(void)setFont:(UIFont *)font{
    textView.font=font;
}

-(UIColor*)textColor{
    return textView.textColor;
}

-(void)setTextColor:(UIColor *)textColor{
    textView.textColor=textColor;
}

-(NSRange)selectedRange{
    return textView.selectedRange;
}

-(void)setSelectedRange:(NSRange)selectedRange{
    textView.selectedRange=selectedRange;
}

-(NSArray<UIImage*>*)images{
    NSMutableArray *ims=[[NSMutableArray alloc] init];
    for(LTTextViewImageContainer *obj in imageContainers){
        [ims addObject:[UIImage imageWithCGImage:obj.image.CGImage]];
    }
    return ims;
}

-(BOOL)isFirstResponder{
    return [textView isFirstResponder];
}

-(BOOL)becomeFirstResponder{
    return [textView becomeFirstResponder];
}

-(BOOL)endEditing:(BOOL)force{
    return [textView endEditing:force];
}

-(BOOL)canBecomeFirstResponder{
    return [textView canBecomeFirstResponder];
}

-(BOOL)resignFirstResponder{
    return [textView resignFirstResponder];
}

-(BOOL)canResignFirstResponder{
    return [textView canResignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setContentsLayout];
}

-(void)setContentsLayout{
    CGRect textRect=[textView.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width-margin*2, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
    NSInteger images=imageContainers.count;
    CGSize imageSize=CGSizeMake(self.frame.size.width-margin*2, self.frame.size.width-margin*2);
    textView.frame=CGRectMake(margin, margin, self.frame.size.width-margin*2, textRect.size.height+textView.font.lineHeight);
    self.contentSize=CGSizeMake(self.frame.size.width, margin+textView.frame.size.height+(images>0?margin*2:0)+images*(imageSize.height+margin*2.0f));
    CGFloat start=textView.frame.size.height+textView.frame.origin.y+margin*2;
    [imageContainers enumerateObjectsUsingBlock:^(LTTextViewImageContainer *obj, NSUInteger index, BOOL *stop){
        CGRect frame=CGRectMake(margin, start+index*(imageSize.height+margin*2), imageSize.width, imageSize.height);
        obj.frame=frame;
    }];
}

-(void)addImage:(UIImage *)image{
    LTTextViewImageContainer *cont=[[LTTextViewImageContainer alloc] init];
    cont.image=image;
    [self addImageContainer:cont];
}

-(void)removeImage:(UIImage *)image{
    if(image==nil){
        [self removeImageContainer:imageContainers.lastObject];
        return;
    }
    [imageContainers enumerateObjectsUsingBlock:^(LTTextViewImageContainer *obj, NSUInteger index, BOOL *stop){
        if([obj.image isEqual:image]){
            [self removeImageContainer:obj];
            *stop=YES;
        }
    }];
}

-(void)addImageContainer:(LTTextViewImageContainer*)container{
    [self addSubview:container];
    container.delegate=self;
    [imageContainers addObject:container];
    [self setContentsLayout];
}

-(void)removeImageContainer:(LTTextViewImageContainer *)container{
    if(![imageContainers containsObject:container]){
        return;
    }
    [container removeFromSuperview];
    [imageContainers removeObject:container];
    [self setContentsLayout];
}

-(void)textViewDidChange:(UITextView *)textView{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:.25 animations:^{
            [self setContentsLayout];
        }];
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return _canDismiss;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    
}

@end
