//
//  hubRequestsViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 4/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "hubRequestsViewController.h"
#import "eventRequestTableCell.h"

@interface hubRequestsViewController (){
    
}

@end

@implementation hubRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Requests"];
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorInset=UIEdgeInsetsZero;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@"no requests!" attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]}];
}

-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

-(UIButton*)leftButton{
    return nil;
}

-(UIButton*)rightButton{
    UIButton *left=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left setImage:[[UIImage imageWithCGImage:[UIImage imageNamed:@"Chevron Left-50.png"].CGImage scale:1.0f orientation:UIImageOrientationUpMirrored] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    left.tintColor=[UIColor whiteColor];
    [left setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, -1, 1)];
    [left addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat margin=5.0f;
    CGFloat leftOffset=20.0f;
    left.imageEdgeInsets=UIEdgeInsetsMake(margin, margin+leftOffset, margin, margin-leftOffset);
    return left;
}

-(void)backPressed:(id)sender{
    [self.pageViewController setPage:1 animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [event sharedInstance].requesting.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    eventRequestTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"requestCell"];
    user *thisUser=[event sharedInstance].requesting[indexPath.row];
    cell.profileImageView.image=thisUser.profileImage;
    [cell.nameLabel setAttributedText:[[NSAttributedString alloc] initWithString:thisUser.name attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]}]];
    cell.leftButtons=@[[MGSwipeButton buttonWithTitle:@"Deny" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender){
        [self respondedToRequestAtIndex:indexPath accepted:NO];
        return YES;
    }]];
    cell.leftSwipeSettings.transition=MGSwipeTransitionStatic;
    cell.leftSwipeSettings.swipeBounceRate=0.25f;
    
    cell.rightButtons=@[[MGSwipeButton buttonWithTitle:@"Accept" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell* sender){
        [self respondedToRequestAtIndex:indexPath accepted:YES];
        return YES;
    }]];
    cell.rightSwipeSettings.transition=MGSwipeTransitionStatic;
    cell.rightSwipeSettings.swipeBounceRate=0.25f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self transitionToProfileForUser:[event sharedInstance].requesting[indexPath.row]];
}

-(void)transitionToProfileForUser:(user*)selectedUser{
    NSLog(@"transition to profile for %@",selectedUser.name);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)respondedToRequestAtIndex:(NSIndexPath*)index accepted:(BOOL)accepted{
    user *requester=[event sharedInstance].requesting[index.row];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:accepted?UITableViewRowAnimationRight:UITableViewRowAnimationLeft];
    [[event sharedInstance].requesting removeObjectAtIndex:index.row];
    [_tableView reloadData];
    [_tableView endUpdates];
    if(accepted){
        [[event sharedInstance].attending addObject:requester];
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
