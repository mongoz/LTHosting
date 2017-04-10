//
//  LTTextView.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/16/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTTextViewImageContainer.h"

@interface LTTextView : UIScrollView<LTTextViewImageContainerDelegate, UITextViewDelegate>

-(void)addImage:(UIImage*)image;

-(void)removeImage:(UIImage*)image;

@property (nonatomic) NSAttributedString *attributedText;

@property (nonatomic) NSString *text;

@property (nonatomic) UITextAutocorrectionType autocorrectionType;

@property (nonatomic) UIFont *font;

@property (nonatomic) UIColor *textColor;

@property (readonly, nonatomic) NSArray<UIImage*> *images;

@property (nonatomic) NSRange selectedRange;

@property (readonly) UITextView *textView;

@property (nonatomic) BOOL canDismiss;

@end
