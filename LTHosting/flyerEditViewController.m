//
//  flyerEditViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "flyerEditViewController.h"
#import "editorView.h"
#import "event.h"
#import "toolsContainer.h"

@interface flyerEditViewController ()

@end

@implementation flyerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    if(_existing!=nil){
        [[editorView shared] removeFromSuperview];
        editorView *archived=[[editorView alloc] initWithCoder:_existing];
        [editorView setSharedInstance:archived];
        [[editorView shared] setFrame:self.editorContainer.bounds];
        [self.editorContainer addSubview:[editorView shared] withIdentifier:@"editor"];
        self.editorContainer.setFrameBlock=^(BBView *v){
            [[editorView shared] setFrame:v.bounds];
        };
        [[editorView shared] setIsEditing:YES];
        [[editorView shared] setViewController:self];
        [self.toolContainer transitionToTool:titleTextTool completion:nil];
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backPressed:(UIBarButtonItem*)item{
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)donePressed:(UIBarButtonItem*)item{
    UIImage *im=[[editorView shared] currentImage];
    CGRect editorFrame=[(editorView*)[editorView shared] frame];
    CGImageRef result=im.CGImage;
    CGFloat width=CGImageGetWidth(result);
    CGFloat scale=width/editorFrame.size.width;
    CGFloat xVal=scale*(editorFrame.size.width-[[editorView shared] backgroundTintLayer].frame.size.width)/2;
    CGImageRef cropped=CGImageCreateWithImageInRect(result, CGRectMake(xVal, 0, width-(xVal*2), CGImageGetHeight(result)));
    
    [[event sharedInstance] setFlyer:[UIImage imageWithCGImage:cropped]];
    CGImageRelease(cropped);
    
    [[editorView shared] removeFromSuperview];
    NSMutableData *flyerData=[NSMutableData data];
    NSKeyedArchiver *archive=[[NSKeyedArchiver alloc] initForWritingWithMutableData:flyerData];
    [[editorView shared] encodeWithCoder:archive];
    [archive finishEncoding];
    [[event sharedInstance] setFlyerObject:flyerData];
    
    [[editorView shared] reset];
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
