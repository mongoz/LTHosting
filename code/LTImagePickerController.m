//
//  LTImagePickerViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/15/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTImagePickerController.h"
#import <BBView/BBView.h>

@interface LTImagePickerController (){
    BBView *topBar;
    BOOL setup;
}

@end

@implementation LTImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    setup=NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(!setup){
        CGFloat barHeight=44.0f;
        topBar=[[BBView alloc] init];
        UILabel *lab=[[UILabel alloc] init];
        lab.text=@"Choose Photo...";
        lab.textColor=[UIColor blackColor];
        lab.textAlignment=NSTextAlignmentCenter;
        UIButton *x=[[UIButton alloc] init];
        [x setTitle:@"X" forState:UIControlStateNormal];
        [x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [x addTarget:self action:@selector(xPressed:) forControlEvents:UIControlEventTouchUpInside];
        topBar[@"button"]=x;
        topBar[@"label"]=lab;
        topBar.backgroundColor=[UIColor groupTableViewBackgroundColor];
        topBar.layer.shadowOpacity=0.5f;
        topBar.layer.shadowColor=[UIColor blackColor].CGColor;
        topBar.layer.shadowRadius=8.0f;
        CGFloat layoutHeight=self.topLayoutGuide.length;
        topBar.layoutSubviewsBlock=^(BBView *view){
            view[@"label"].frame=CGRectMake(0, layoutHeight, view.frame.size.width, view.frame.size.height-layoutHeight);
            CGFloat margin=4.0f;
            CGFloat height=view.frame.size.height-margin*2-layoutHeight;
            view[@"button"].frame=CGRectMake(view.frame.size.width-margin-height, margin+layoutHeight, height, height);
        };
        topBar.frame=CGRectMake(0, 0, self.view.frame.size.width, barHeight+self.topLayoutGuide.length);
        [self.view addSubview:topBar];
        self.pickerView=[[LTImagePicker alloc] init];
        self.pickerView.frame=CGRectMake(0, topBar.frame.size.height, topBar.frame.size.width, self.view.bounds.size.height-topBar.frame.size.height);
        self.pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.pickerDelegate=self;
        [self.view insertSubview:self.pickerView belowSubview:topBar];
        [self.pickerView reloadImagesWithCompletionBlock:^{
            NSLog(@"images fetched");
        }];
        setup=YES;
    }
    
}

-(void)xPressed:(UIButton*)x{
    if(_delegate!=nil&&[_delegate respondsToSelector:@selector(controllerDidCancelPicking:)]){
        [_delegate controllerDidCancelPicking:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginCameraModeWithImagePicker:(LTImagePicker *)picker{
    UIImagePickerController *ip=[[UIImagePickerController alloc] init];
    ip.delegate=picker;
    [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
    [ip setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    [self presentViewController:ip animated:YES completion:nil];
}

-(void)endCameraModeWithImagePicker:(LTImagePicker *)picker completion:(void (^)())completionBlock{
    [self dismissViewControllerAnimated:YES completion:^{
        if(completionBlock!=nil){
            completionBlock();
        }
    }];
}

-(void)imagePicker:(LTImagePicker *)picker didFinishChoosingWithImage:(UIImage *)image{
    if(_delegate!=nil&&[_delegate respondsToSelector:@selector(controller:didFinishPickingImage:)]){
        [_delegate controller:self didFinishPickingImage:image];
    }
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
