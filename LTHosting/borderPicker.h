//
//  borderPicker.h
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "tool.h"
#import "horizontalViewPicker.h"

@interface borderPicker : tool<horizontalViewPickerDelegate,horizontalViewPickerDataSource>

+(NSInteger)selectedIndex;

@end
