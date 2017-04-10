//
//  textEditor.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textEditorDelegate;

@interface textEditor : UIVisualEffectView <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<textEditorDelegate> delegate;

@property (nonatomic) NSAttributedString *attributedText;

@property (weak, nonatomic) id target;

@end

@protocol textEditorDelegate <NSObject>

-(void)textEditor:(textEditor*)editor finishedEditingWithResult:(NSAttributedString*)resultString;

@end
