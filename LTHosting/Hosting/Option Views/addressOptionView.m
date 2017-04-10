//
//  addressOptionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "addressOptionView.h"
#import "stackView.h"
#import "stackTableView.h"

@interface addressOptionView(){
    UITextField *field;
    
    GMSPlacesClient *myClient;
    NSArray<GMSAutocompletePrediction*>* resultsArray;
    GMSAutocompletePrediction *mostRecentPrediction;
    UITableView *searchTable;
}
@end

@implementation addressOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeight
{
    self=[super initWithFrame:frame barHeight:barHeight];
    for(UIView *v in self.barView.subviews)
    {
        if(v.class==[UITextField class])
        {
            field=(UITextField*)v;
            field.delegate=self;
            break;
        }
    }
    [self configureAccessoryView];
    myClient=[[GMSPlacesClient alloc] init];
    resultsArray=[[NSArray alloc] init];
    mostRecentPrediction=nil;
    return self;
}

-(BOOL)hasAccessoryView
{
    return YES;
}

-(void)configureAccessoryView
{
    CGRect accessoryFrame=CGRectMake(0, self.barView.frame.origin.y+self.barView.frame.size.height, self.barView.frame.size.width, self.frame.size.height-self.barView.frame.size.height);
    self.accessoryView=[[stackView alloc] initWithFrame:accessoryFrame];
    searchTable=[[stackTableView alloc] initWithFrame:self.accessoryView.bounds];
    searchTable.delegate=self;
    searchTable.dataSource=self;
    [searchTable.layer setBorderColor:[UIColor blackColor].CGColor];
    [searchTable setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.accessoryView addSubview:searchTable];
    [self.accessoryView.layer setShadowColor:self.barView.layer.shadowColor];
    [self.accessoryView.layer setShadowRadius:self.barView.layer.shadowRadius];
    [self.accessoryView.layer setShadowOpacity:self.barView.layer.shadowOpacity];
    
    [self addArrangedSubview:self.accessoryView];
    [field addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.accessoryView.hidden=YES;
    
    field.placeholder=@"Add Location...";
    field.attributedPlaceholder=[[NSAttributedString alloc] initWithString:field.placeholder attributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName]];
    [self.barView addSubview:field];
    
    [self.accessoryView setAutoresizesSubviews:YES];
    [self.accessoryView.layer setMasksToBounds:YES];
    [self bringSubviewToFront:self.barView];
}

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
    if(!new)
    {
        new=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    [new setSeparatorInset:UIEdgeInsetsZero];
    GMSAutocompletePrediction *prediction=resultsArray[indexPath.row];
    new.textLabel.text=prediction.attributedPrimaryText.string;
    new.detailTextLabel.text=prediction.attributedSecondaryText.string;
    new.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return new;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [field setText:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    mostRecentPrediction=resultsArray[indexPath.row];
    if([field isEditing])
    {
        [field endEditing:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.isAccessoryViewShowing)
    {
        [self tapBar];
    }
}

-(IBAction)textChanged:(UITextField*)f
{
    [self searchForString:f.text];
    if(!self.isAccessoryViewShowing)
    {
        [super tapBar];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)tapBar
{
    if(field.isEditing&&self.isAccessoryViewShowing)
    {
        [field endEditing:YES];
    }
    [super tapBar];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.isAccessoryViewShowing)
    {
        [super tapBar];
    }
    
}

-(void)searchForString:(NSString *)string
{
    [myClient autocompleteQuery:string bounds:nil filter:nil callback:^(NSArray<GMSAutocompletePrediction*> *predictions, NSError *error){
        NSMutableArray *newResultsArray=[[NSMutableArray alloc] init];
        for(NSInteger i=0; i<predictions.count; i++)
        {
            [newResultsArray addObject:predictions[i]];
        }
        resultsArray=newResultsArray;
        //[self printArray:resultsArray];
        [searchTable reloadData];
    }];
}

-(void)detailEditingWillEnd
{
    [[event sharedInstance] setAddress:field.text];
    if(mostRecentPrediction!=nil)
    {
        [[GMSPlacesClient sharedClient] lookUpPlaceID:mostRecentPrediction.placeID callback:^(GMSPlace *place, NSError *error){
            if(!error)
            {
                [[event sharedInstance] setFullAddressInfo:place];
            }
        }];
    }
}

-(NSString*)optionName
{
    return @"Location";
}



@end
