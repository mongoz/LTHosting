//
//  testEvent.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/26/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "testEvent.h"
#import "testUser.h"

@implementation testEvent

+(event*)get{
    NSData *objectData=[NSData dataWithContentsOfFile:[self filePath]];
    NSKeyedUnarchiver *unarchive=[[NSKeyedUnarchiver alloc] initForReadingWithData:objectData];
    event *mine=[[event alloc] initWithCoder:unarchive];
    [unarchive finishDecoding];
    return mine;
}

+(void)set:(event*)test{
    test.poster=[testUser get];
    user *testU=[testUser get];
    void (^add10To)(NSMutableArray*)=^(NSMutableArray *arr){
        for(int i=0; i<10; i++){
            [arr addObject:testU];
        }
    };
    add10To(test.requesting);
    add10To(test.attending);
    NSMutableData *mutableData=[NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [test encodeWithCoder:archiver];
    [archiver finishEncoding];
    [mutableData writeToFile:[self filePath] atomically:YES];
    
}

static NSString* TEST_EVENT_FILE_PATH=nil;

+(NSString*)filePath{
    if(TEST_EVENT_FILE_PATH==nil){
        NSString *docsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        TEST_EVENT_FILE_PATH= [docsPath stringByAppendingString:@"/testEvent"];
    }
    NSLog(@"%@",TEST_EVENT_FILE_PATH);
    return TEST_EVENT_FILE_PATH;
}

@end
