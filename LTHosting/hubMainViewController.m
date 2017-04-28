//
//  hubMainViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "hubMainViewController.h"
#import <BBView/BBView.h>
#import "flyerEditViewController.h"
#import "editorView.h"

@interface hubMainViewController (){
    //The array below will define each button's image, title, and action
    NSArray<NSArray*>* buttonInfo;
    UIButton *attendanceLabel;
}

@property (readonly) CGFloat verticalMargin;

@end

@implementation hubMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonInfo=[self createButtonInfo];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Hub"];
    
    [self.flyerView setContentMode:UIViewContentModeScaleAspectFit];
    
    CGFloat margin=8.0f;
    
    BBView *rectangle=[[BBView alloc] initWithFrame:CGRectMake(margin, margin, _infoView.frame.size.width-(margin*2), _infoView.frame.size.height-(margin*2))];
    rectangle.backgroundColor=[UIColor lightGrayColor];
    rectangle.layer.cornerRadius=4.0f;
    rectangle.layer.masksToBounds=YES;
    [_infoView addSubview:rectangle withIdentifier:@"rect"];
    _infoView.setFrameBlock=^(BBView *v){
        rectangle.frame=CGRectMake(margin, margin, v.frame.size.width-(margin*2), v.frame.size.height-(margin*2));
    };
    
    attendanceLabel=[[UIButton alloc] initWithFrame:rectangle.bounds];
    [rectangle addSubview:attendanceLabel withIdentifier:@"label"];
    rectangle.setFrameBlock=^(BBView *v){
        attendanceLabel.frame=v.bounds;
    };
    
    
}

-(NSAttributedString*)attributedTitleForString:(NSString*)title{
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]}];
}

-(NSArray<NSArray*>*)createButtonInfo{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    void (^add)(NSString*,NSString*,void(^)())=^(NSString *buttonText, NSString *imageName, void(^actionBlock)()){
        [arr addObject:@[buttonText,[UIImage imageNamed:imageName],actionBlock]];
    };
    add(@"Requests",@"hourglass.png",^{
        [_pageViewController setPage:0 animated:YES];
    });
    add(@"Edit Flyer",@"hourglass.png",^{
        UIStoryboard *hosting=[UIStoryboard storyboardWithName:@"HostingHub" bundle:[NSBundle mainBundle]];
        UINavigationController *nav=[hosting instantiateViewControllerWithIdentifier:@"flyerEditor"];
        flyerEditViewController *flyerEditor=(flyerEditViewController*)nav.topViewController;
        NSKeyedUnarchiver *getEditor=[[NSKeyedUnarchiver alloc] initForReadingWithData:[event sharedInstance].flyerObject];
        flyerEditor.existing=getEditor;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    });
    add(@"Invite",@"hourglass.png",^{
        [_pageViewController setPage:2 animated:YES];
    });
    return arr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _flyerView.image=[event sharedInstance].flyer;
    [attendanceLabel setAttributedTitle:[self attributedTitleForString:[NSString stringWithFormat:@"%ld Attending",[event sharedInstance].attending.count]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Collection View Protocol Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return buttonInfo.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)view cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[view dequeueReusableCellWithReuseIdentifier:@"hubCell" forIndexPath:indexPath];
    NSArray *data=buttonInfo[indexPath.item];
    BBView *content=[[BBView alloc] init];
    UILabel *text=[[UILabel alloc] init];
    text.numberOfLines=1;
    text.textAlignment=NSTextAlignmentCenter;
    UIImageView *image=[[UIImageView alloc] initWithImage:(UIImage*)data[1]];
    image.contentMode=UIViewContentModeScaleAspectFit;
    text.attributedText=[[NSAttributedString alloc] initWithString:(NSString*)data.firstObject attributes:@{}];
    [text sizeToFit];
    [content addSubview:text];
    [content addSubview:image];
    content.setFrameBlock=^(BBView *v){
        CGFloat theight=text.frame.size.height*1.618;
        [image setFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height-theight)];
        [text setFrame:CGRectMake(0, image.frame.size.height, v.frame.size.width, theight)];
    };
    content.frame=cell.bounds;
    [cell addSubview:content];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    void (^doBlock)()=buttonInfo[indexPath.item][2];
    if(doBlock!=nil){
        doBlock();
    }
}

-(CGFloat)verticalMargin{
    return 4.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat buffer=[self buffer:collectionViewLayout];
    return UIEdgeInsetsMake(self.verticalMargin,buffer,self.verticalMargin,buffer);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=_controlView.frame.size.height-(self.verticalMargin*2);
    return CGSizeMake(height, height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self buffer:collectionViewLayout];
}

-(CGFloat)buffer:(UICollectionViewLayout*)collectionViewLayout{
    NSInteger cells=[self collectionView:_controlView numberOfItemsInSection:0];
    CGFloat cellWidth=[self collectionView:_controlView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].width;
    CGFloat extra=_controlView.frame.size.width-(cellWidth*cells);
    return extra/(cells+1);
}

-(UIButton*)leftButton{
    UIButton *left=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left setImage:[[UIImage imageNamed:@"Chevron Left-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    left.tintColor=[UIColor whiteColor];
    [left addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat margin=5.0f;
    CGFloat leftOffset=20.0f;
    left.imageEdgeInsets=UIEdgeInsetsMake(margin, margin-leftOffset, margin, margin+leftOffset);
    return left;
}

-(void)backPressed:(id)sender{
    [self.pageViewController.navigationController popViewControllerAnimated:YES];
}

-(UIButton*)rightButton{
    return nil;
}

@end
