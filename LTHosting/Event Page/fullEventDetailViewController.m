//
//  fullEventDetailViewController.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "fullEventDetailViewController.h"
#import "REAttributedStringItem.h"
#import "locationItem.h"
#import "cblock.h"

@interface fullEventDetailViewController (){
    RETableViewSection *section;
}

@end

@implementation fullEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[cblock make:^id{
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Chevron Left-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
        item.tintColor=[UIColor whiteColor];
        CGFloat cushion=8.0f;
        CGFloat right=24.0f;
        [item setImageInsets:UIEdgeInsetsMake(cushion, cushion-right, cushion, cushion+right)];
        return item;
    }]];
    
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.manager=[[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    self.manager[@"REAttributedStringItem"]=@"REAttributedStringCell";
    self.manager[@"locationItem"]=@"locationCell";
    section=[[RETableViewSection alloc] initWithHeaderView:nil];
    UIFont *bodyFont=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    RETableViewSection *nameSection=[[RETableViewSection alloc] initWithHeaderView:[self headerViewForTitle:@"Name"]];
    [nameSection addItem:[REAttributedStringItem itemWithString:_event.name font:bodyFont]];
    [self.manager addSection:nameSection];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    RETableViewSection *dateSection=[[RETableViewSection alloc] initWithHeaderView:[self headerViewForTitle:@"Date"]];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateStyle=NSDateFormatterLongStyle;
    [formatter setDateFormat:@"h:mm a, MMMM d"];
    [dateSection addItem:[REAttributedStringItem itemWithString:[formatter stringFromDate:_event.date] font:bodyFont]];
    [self.manager addSection:dateSection];
    
    RETableViewSection *locationSection=[[RETableViewSection alloc] initWithHeaderView:[self headerViewForTitle:@"Location"]];
    [locationSection addItem:[locationItem itemWithPlace:_event.fullAddressInfo addressString:_event.address]];
    [self.manager addSection:locationSection];
    
    RETableViewSection *aboutSection=[[RETableViewSection alloc] initWithHeaderView:[self headerViewForTitle:@"About"]];
    [aboutSection addItem:[REAttributedStringItem itemWithString:_event.about font:bodyFont]];
    if(_event.music.length>0)
    {
        NSMutableAttributedString *string=[[NSMutableAttributedString alloc] init];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"Music: " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:bodyFont.pointSize]}]];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:_event.music attributes:@{NSFontAttributeName:bodyFont}]];
        [aboutSection addItem:[REAttributedStringItem itemWithAttributedString:string]];
    }
    if(_event.venue.length>0)
    {
        NSMutableAttributedString *string=[[NSMutableAttributedString alloc] init];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"Venue: " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:bodyFont.pointSize]}]];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:_event.venue attributes:@{NSFontAttributeName:bodyFont}]];
        [aboutSection addItem:[REAttributedStringItem itemWithAttributedString:string]];
    }
    if(!_event.isFree)
    {
        [aboutSection addItem:[REAttributedStringItem itemWithString:@"Entry Fee" font:[UIFont boldSystemFontOfSize:bodyFont.pointSize]]];
    }
    if(_event.isPrivate)
    {
        [aboutSection addItem:[REAttributedStringItem itemWithString:@"Private" font:[UIFont boldSystemFontOfSize:bodyFont.pointSize]]];
    }
    [self.manager addSection:aboutSection];
}

-(void)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView*)headerViewForTitle:(NSString*)title
{
    UIFont *font=[UIFont boldSystemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3].pointSize];
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, font.lineHeight*1.618f)];
    header.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0, header.frame.size.width-8.0f, header.frame.size.height)];;
    [header addSubview:lab];
    [lab setAttributedText:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font}]];
    return header;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

@end
