//
//  ViewController.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/5/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventPageViewController.h"
#import "eventPageHeaderView.h"
#import "flyerTableViewItem.h"
#import "seperatorTableViewItem.h"
#import "eventTableViewItem.h"
#import "fullEventDetailViewController.h"
#import "commentsHeaderView.h"
#import "commentAddContainer.h"
#import "eventCommentTableViewItem.h"
@import GooglePlaces;

@interface eventPageViewController (){
    RETableViewSection *info;
    RETableViewSection *comments;
    CLLocationManager *locationManager;
    eventPageFooterView *footer;
    commentsHeaderView *commentsHeader;
    commentAddContainer *commentEditingContainer;
    BOOL laidout;
    BOOL footerShowing;
}

@end

@implementation eventPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    laidout=NO;
    commentEditingContainer=nil;
    // Do any additional setup after loading the view, typically from a nib
    [_tableView setFrame:self.view.bounds];
    _tableView.delaysContentTouches=NO;
    _manager=[[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    _manager[@"flyerTableViewItem"]=@"flyerTableViewCell";
    _manager[@"seperatorTableViewItem"]=@"seperatorCell";
    _manager[@"eventTableViewItem"]=@"eventDetailTableViewCell";
    _manager[@"eventCommentTableViewItem"]=@"eventCommentTableViewCell";
   _header=[eventPageHeaderView headerViewForUser:_event.poster withWidth:self.view.frame.size.width];
    _header.backgroundColor=[UIColor whiteColor];
    _header.profileTransitionController=self;
    [self.view addSubview:_header];
    footer=[eventPageFooterView footerViewWithWidth:self.view.frame.size.width];
    footer.delegate=self;
    footer.layer.zPosition=CGFLOAT_MAX;
    [self.navigationController.view addSubview:footer];
    footerShowing=YES;
    [self startStandardUpdates];
    [self createSampleEvent:^{
        _header.poster=_event.poster;
        info=[[RETableViewSection alloc] initWithHeaderView:nil];
        [info addItem:[flyerTableViewItem itemWithFlyer:[UIImage imageNamed:@"exampleFlyer.jpg"] transitionController:self]];
        [info addItem:[eventTableViewItem itemWithEvent:_event locationManager:locationManager transitionController:self]];
        [_manager addSection:info];
        commentsHeader=[[commentsHeaderView alloc] initWithUser:_event.poster transitionController:self];
        commentsHeader.frame=CGRectMake(0, 0, self.view.frame.size.width, 64.0f);
        comments=[[RETableViewSection alloc] initWithHeaderView:commentsHeader];
        [comments addItem:[seperatorTableViewItem itemWithColor:[UIColor whiteColor] height:footer.frame.size.height]];
        [_manager addSection:comments];
        [_tableView reloadData];
    }];
}

-(void)didPressAccept:(eventPageFooterView *)view{
    
}

-(void)didPressDeny:(eventPageFooterView *)view{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.footerShowing=NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.footerShowing=YES;
}

-(void)setFooterShowing:(BOOL)fShowing{
    if(fShowing!=footerShowing){
        CGFloat var=fShowing?-footer.frame.size.height:0;
        [UIView animateWithDuration:.25 animations:^{
            footer.frame=CGRectMake(0, self.view.frame.size.height+var+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, footer.frame.size.width, footer.frame.size.height);
        } completion:^(BOOL finished){
            footerShowing=fShowing;
        }];
    }
}

-(BOOL)footerShowing{
    return footerShowing;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(!laidout){
        
        [footer layoutIfNeeded];
        [self.view bringSubviewToFront:footer];
        [self reloadData];
        laidout=YES;
    }
    footer.frame=CGRectMake(0, self.view.frame.size.height-footer.frame.size.height+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, footer.frame.size.width, footer.frame.size.height);
    _tableView.frame=CGRectMake(_header.frame.origin.x, _header.frame.origin.y+_header.frame.size.height, _header.frame.size.width, self.view.frame.size.height-_header.frame.size.height-_header.frame.origin.y);
    
}

-(void)createSampleEvent:(void(^)())completionBlock;
{
    _event=[[event alloc] init];
    _event.name=@"Party";
    _event.about=@"About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah. About paragraph explaining how great this event will be and blah blah blah blah blah.";
    _event.date=[NSDate dateWithTimeIntervalSinceNow:3600*6];
    _event.music=@"Hip hop";
    _event.venue=@"Party";
    _event.isPrivate=YES;
    _event.isFree=YES;
    _event.address=@"John Street";
    user *testPoster=[[user alloc] init];
    testPoster.name=@"Don Johnson";
    testPoster.profileImage=[UIImage imageNamed:@"profileImage.jpeg"];
    _event.poster=testPoster;
    [[GMSPlacesClient sharedClient] lookUpPlaceID:@"ChIJt00z67a1j4ARL8h-xOZ1XVo" callback:^(GMSPlace *place, NSError *error){
        _event.fullAddressInfo=place;
        _event.address=place.name;
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }];
}

-(void)startStandardUpdates
{
    if(locationManager==nil)
    {
        locationManager=[[CLLocationManager alloc] init];
    }
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=500;
    [locationManager startUpdatingLocation];
}

-(void)stopStandardUpdates
{
    if(locationManager!=nil)
    {
        [locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self reloadData];
}

-(void)reloadData
{
    [info reloadSectionWithAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)transitionToProfileForUser:(user *)user
{
    NSLog(@"transition to profile for %@",user.name);
}

-(void)transitionToEventDetails:(event*)event
{
    [self performSegueWithIdentifier:@"eventDetails" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc=[segue destinationViewController];
    if([vc class]==[fullEventDetailViewController class])
    {
        [(fullEventDetailViewController*)vc setEvent:_event];
    }
}

-(void)shouldBeginCommentEditingWithHeader:(commentsHeaderView *)headera
{
    
    commentAddView *v=[headera retrieveCommentAddView];
    CGRect headerFrame=[self frameOfHeaderForSection:comments];
    v.frame=headerFrame;
    commentEditingContainer=[[commentAddContainer alloc] initWithTransitionController:self];
    commentEditingContainer.frame=self.view.frame;
    [self.navigationController.view addSubview:commentEditingContainer];
    _tableView.scrollEnabled=NO;
    [commentEditingContainer giveCommentAddView:v];
}

-(void)containerDidEndEditing:(commentAddContainer *)container
{
    commentAddView *v=[container retrieveCommentAddView];
    [container removeFromSuperview];
    [commentsHeader returnCommentAddView:v];
    _tableView.scrollEnabled=YES;
}

-(CGRect)frameOfHeaderForSection:(RETableViewSection*)section
{
    CGFloat height=_header.frame.size.height;
    for(NSInteger i=0; i<section.index; i++)
    {
        height+=[self heightOfSection:section.tableViewManager.sections[i]];
    }
    return CGRectMake(section.headerView.frame.origin.x, height-section.tableViewManager.tableView.contentOffset.y, section.headerView.frame.size.width, section.headerView.frame.size.height);
}

-(CGRect)frameOfCellForItem:(RETableViewItem*)item
{
    NSIndexPath *path=item.indexPath;
    CGFloat totalHeight=_header.frame.size.height;
    for(NSInteger i=0; i<path.row; i++)
    {
        RETableViewItem *thisItem=item.section.items[i];
        totalHeight+=[self heightOfRowForItem:thisItem];
    }
    if(item.section.headerView!=nil)
    {
        totalHeight+=item.section.headerView.frame.size.height;
    }
    for(NSInteger i=0; i<path.section; i++)
    {
        totalHeight+=[self heightOfSection:item.section.tableViewManager.sections[i]];
    }
    return CGRectMake(0, totalHeight-_tableView.contentOffset.y, _tableView.frame.size.width, [self heightOfRowForItem:item]);
}

-(CGFloat)heightOfSection:(RETableViewSection*)section
{
    CGFloat total=0.0f;
    for(RETableViewItem *item in section.items)
    {
        total+=[self heightOfRowForItem:item];
    }
    if(section.headerView!=nil)
    {
        total+=section.headerView.frame.size.height;
    }
    return total;
}

-(CGFloat)heightOfRowForItem:(RETableViewItem*)item
{
    if(item.section.tableViewManager==nil)
    {
        return 0;
    }
    return [[item.section.tableViewManager classForCellAtIndexPath:item.indexPath] heightWithItem:item tableViewManager:item.section.tableViewManager];
}

-(void)showImagePicker{
    LTImagePickerController *cont=[[LTImagePickerController alloc] init];
    cont.view.frame=self.navigationController.view.bounds;
    cont.delegate=self;
    [self presentViewController:cont animated:YES completion:nil];
}

-(void)controller:(LTImagePickerController *)controller didFinishPickingImage:(UIImage *)image{
    if(commentEditingContainer.superview==nil){
        [self shouldBeginCommentEditingWithHeader:commentsHeader];
    }
    [commentEditingContainer.addView addImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)controllerDidCancelPicking:(LTImagePickerController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addCommentToComments:(eventComment*)comment{
    eventCommentTableViewItem *com=[[eventCommentTableViewItem alloc] initWithComment:comment];
    com.transitionController=self;
    [_tableView beginUpdates];
    [comments insertItem:com atIndex:comments.items.count-1];
    [_tableView insertRowsAtIndexPaths:@[com.indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [_tableView endUpdates];
}

-(void)postComment:(eventComment *)comment{
    NSLog(@"post comment");
    [self addCommentToComments:comment];
}

-(void)displayImageView:(UIImageView *)view{
    CGRect rect=[view convertRect:view.bounds toView:nil];
    [view removeFromSuperview];
    imageInspectionView *inspect=[[imageInspectionView alloc] initWithFrame:self.navigationController.view.bounds];
    [self.navigationController.view addSubview:inspect];
    view.frame=rect;
    
    inspect.imageView=view;
    inspect.delegate=self;
    self.footerShowing=NO;
}

-(void)inspectionViewDidDismiss:(imageInspectionView *)view{
    [view removeFromSuperview];
    self.footerShowing=YES;
}

@end
