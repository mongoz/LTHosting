//
//  addressSearchResultsViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/4/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "addressSearchResultsViewController.h"

@interface addressSearchResultsViewController (){
    GMSPlacesClient *myClient;
    NSArray<GMSAutocompletePrediction*>* resultsArray;
}
@end

@implementation addressSearchResultsViewController

- (void)viewDidLoad {
    _searchResultsTableView.delegate=self;
    _searchResultsTableView.dataSource=self;
    myClient=[[GMSPlacesClient alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//Table Delegate/Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    [new setSeparatorInset:UIEdgeInsetsZero];
    GMSAutocompletePrediction *prediction=resultsArray[indexPath.row];
    new.textLabel.text=prediction.attributedPrimaryText.string;
    new.detailTextLabel.text=prediction.attributedSecondaryText.string;
    return new;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parent completeAddressWithString:resultsArray[indexPath.row].attributedPrimaryText.string];
}

//Methods to search for autocomplete results
-(void)searchForString:(NSString *)string
{
    [self.view setUserInteractionEnabled:NO];
    [myClient autocompleteQuery:string bounds:nil filter:nil callback:^(NSArray<GMSAutocompletePrediction*> *predictions, NSError *error){
        NSMutableArray *newResultsArray=[[NSMutableArray alloc] init];
        for(NSInteger i=0; i<predictions.count; i++)
        {
            [newResultsArray addObject:predictions[i]];
        }
        resultsArray=newResultsArray;
        //[self printArray:resultsArray];
        [_searchResultsTableView reloadData];
    }];
    [self.view setUserInteractionEnabled:YES];
}

-(void)printArray:(NSArray*)array
{
    for(NSInteger i=0; i<array.count; i++)
    {
        //NSLog(@"%ld: %@",(long)i,array[i]);
    }
}

-(void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [_searchResultsTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end
