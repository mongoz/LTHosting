//
//  fontPopupToolView.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "popupToolView.h"
#import "horizontalViewPicker.h"
#import "usefulArray.h"

@interface fontPopupToolView : popupToolView <horizontalViewPickerDataSource, horizontalViewPickerDelegate>

@property (strong, nonatomic) horizontalViewPicker *fontPicker;

@end
