//
//  testEvent.h
//  LTHosting
//
//  Created by Cam Feenstra on 4/26/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "event.h"

@interface testEvent : event

+(event*)get;

+(void)set:(event*)event;

@end
