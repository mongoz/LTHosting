//
//  switchOptionView.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionVIew.h"

typedef enum LTeventOptionSwitchType{
    LTswitchOptionFree,
    LTswitchOptionPrivate
}eventOptionSwitchType;

@interface switchOptionView : eventOptionView

@property (readonly) eventOptionSwitchType toolType;

-(id)initWithFrame:(CGRect)frame type:(eventOptionSwitchType)type barHeight:(CGFloat)barHeight;

@end
