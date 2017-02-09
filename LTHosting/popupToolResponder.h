//
//  popupToolResponder.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#ifndef popupToolResponder_h
#define popupToolResponder_h

//popupToolResponder protocol declaration

@protocol popupToolResponder <NSObject>

@required

@property CGFloat borderWidth;

@property CGFloat cornerRadius;

-(CGColorRef)color;

-(void)colorDidChangeTo:(CGColorRef)color;

@optional

-(NSTextAlignment)textAlignment;

-(CGFloat)fontSize;

-(CGFloat)maxTextSize;

-(void)borderWidthDidChangeTo:(CGFloat)bwidth;

-(void)cornerRadiusDidChangeTo:(CGFloat)radius;

-(void)fontDidChangeTo:(UIFont*)font;

-(void)textAlignmentDidChangeTo:(NSTextAlignment)alignment;

-(void)fontSizeDidChangeTo:(CGFloat)fontSize;

-(void)shadeDidChangeTo:(CGFloat)shade;

-(void)removeColor;

@end


#endif /* popupToolResponder_h */
