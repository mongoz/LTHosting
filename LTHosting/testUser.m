//
//  testUser.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "testUser.h"

@implementation testUser

+(user*)get{
    user *testPoster=[[user alloc] init];
    testPoster.name=@"Don Johnson";
    testPoster.profileImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profileImage" ofType:@"jpeg"]];
    return testPoster;
}

@end
