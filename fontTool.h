//
//  fontTool.h
//  LTHosting
//
//  Created by Cam Feenstra on 3/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "tool.h"
#import "horizontalViewPicker.h"

@interface fontTool : tool<horizontalViewPickerDelegate,horizontalViewPickerDataSource>

+(NSInteger)bodyIndex;

+(void)setBodyIndex:(NSInteger)index;

+(NSInteger)titleIndex;

+(void)setTitleIndex:(NSInteger)index;

@end
