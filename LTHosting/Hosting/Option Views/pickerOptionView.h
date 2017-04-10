//
//  pickerOptionView.h
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionVIew.h"

typedef enum eventOptionPickerViewType{
    LTPickerOptionMusic,
    LTPickerOptionVenue
}pickerOptionType;

@interface pickerOptionView : eventOptionView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (readonly) pickerOptionType toolType;

-(id)initWithFrame:(CGRect)frame type:(pickerOptionType)type barHeight:(CGFloat)barHeight;

@end
