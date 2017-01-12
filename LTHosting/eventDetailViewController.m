//
//  eventDetailViewController.m
//  LTHosting
//
//  Created by Cam Feenstra on 12/31/16.
//  Copyright © 2016 Cam Feenstra. All rights reserved.
//

#import "eventDetailViewController.h"
#import "eventOptionsTextTableViewCell.h"
#import "eventOptionsFieldTableViewCell.h"
#import "eventOptionsSwitchTableViewCell.h"
#import "eventOptionTableViewCell.h"
#import "sliderViewController.h"
#import "addressSearchResultsViewController.h"

@interface eventDetailViewController (){
    NSDictionary<NSString*,NSNumber*> *optionTypes;
    NSDictionary<NSString*,NSNumber*> *optionRows;
    NSDictionary<NSString*,id> *initialStates;
    CGFloat typeHeights[10];
    
    BOOL keyboardShowing;
    BOOL sliderShowing;
    BOOL addressSearchShowing;
    
    sliderViewController *child;
    sliderViewController *newChild;
    CGFloat sliderProportion;
    
    UIView *searchResultsView;
    addressSearchResultsViewController *searchResultsChild;
    
    CGRect keyboardFrame;
}
@end

@implementation eventDetailViewController

- (void)viewDidLoad {
    [self configureView];
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _creation=[event sharedInstance];
    _creation.date=[NSDate date];
    [self.view setAutoresizesSubviews:NO];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    // Do any additional setup after loading the view.
}

-(void)configureView
{
    [self generateOptionRows];
    [self generateOptionTypes];
    [self generateInitialStates];
    [self generateTypeHeights];
    [self setInitialFrames];
    [_optionsTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    keyboardShowing=NO;
    sliderShowing=NO;
    addressSearchShowing=NO;
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    keyboardFrame=keyboardFrameBeginRect;
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    
}

-(void)setInitialFrames
{
    sliderProportion=2;
    CGRect viewRect=self.view.frame;
    [_navBar setFrame:CGRectMake(0, 20, viewRect.size.width, 44)];
    [_optionsTableView setFrame:CGRectMake(0, 64, viewRect.size.width, viewRect.size.height-64)];
    [_slidingView setFrame:CGRectMake(0, viewRect.size.height, viewRect.size.width, viewRect.size.height/sliderProportion)];
}

-(void)generateOptionTypes
{
    /*
     type 0: text box, one line
     type 1: text box. multiple lines
     type 2: text, "add" button
     type 3: switch, two options
     type 4: last row, includes continue button
     */
    
    NSMutableDictionary<NSString*,NSNumber*> *generate=[[NSMutableDictionary alloc] init];
    [generate setObject:[NSNumber numberWithInteger:0] forKey:@"Name"];
    [generate setObject:[NSNumber numberWithInteger:0] forKey:@"Address"];
    [generate setObject:[NSNumber numberWithInteger:1] forKey:@"About"];
    [generate setObject:[NSNumber numberWithInteger:2] forKey:@"Date"];
    [generate setObject:[NSNumber numberWithInteger:3] forKey:@"Private"];
    [generate setObject:[NSNumber numberWithInteger:3] forKey:@"Free"];
    [generate setObject:[NSNumber numberWithInteger:2] forKey:@"Music"];
    [generate setObject:[NSNumber numberWithInteger:2] forKey:@"Venue"];
    [generate setObject:[NSNumber numberWithInteger:4] forKey:@"Go"];
    [generate setObject:[NSNumber numberWithInteger:5] forKey:@"Image"];
    optionTypes=[generate copy];
}

-(void)generateOptionRows
{
    NSMutableDictionary<NSString*,NSNumber*> *generate=[[NSMutableDictionary alloc] init];
    [generate setObject:[NSNumber numberWithInteger:0] forKey:@"Name"];
    [generate setObject:[NSNumber numberWithInteger:1] forKey:@"Address"];
    [generate setObject:[NSNumber numberWithInteger:2] forKey:@"About"];
    [generate setObject:[NSNumber numberWithInteger:3] forKey:@"Date"];
    [generate setObject:[NSNumber numberWithInteger:4] forKey:@"Private"];
    [generate setObject:[NSNumber numberWithInteger:5] forKey:@"Free"];
    [generate setObject:[NSNumber numberWithInteger:6] forKey:@"Music"];
    [generate setObject:[NSNumber numberWithInteger:7] forKey:@"Venue"];
    [generate setObject:[NSNumber numberWithInteger:8] forKey:@"Image"];
    [generate setObject:[NSNumber numberWithInteger:9] forKey:@"Go"];
    optionRows=[generate copy];
}

-(void)generateInitialStates
{
    NSMutableDictionary<NSString*,id> *generate=[[NSMutableDictionary alloc] init];
    [generate setObject:@"Add" forKey:@"Name"];
    [generate setObject:@"Add" forKey:@"Address"];
    [generate setObject:@"Add" forKey:@"About"];
    [generate setObject:[NSDate distantPast] forKey:@"Date"];
    [generate setObject:[NSNumber numberWithBool:YES] forKey:@"Private"];
    [generate setObject:[NSNumber numberWithBool:YES] forKey:@"Free"];
    [generate setObject:@"Add" forKey:@"Music"];
    [generate setObject:@"Add" forKey:@"Venue"];
    initialStates=generate;
}

-(void)generateTypeHeights
{
    typeHeights[0]=60;
    typeHeights[1]=120;
    typeHeights[2]=60;
    typeHeights[3]=60;
    typeHeights[4]=60;
    typeHeights[5]=60;
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

//TableViewDelegate/DataSource Protocol Methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option=[optionRows allKeysForObject:[NSNumber numberWithInteger:indexPath.row]].firstObject;
    NSNumber *type=[optionTypes objectForKey:option];
    eventOptionTableViewCell *new=[eventOptionTableViewCell cellForOption:option type:type table:tableView withParent:self];
    new.parent=self;
    return new;
}

-(void)setTableTextView:(UITextView *)tableTextView
{
    _tableTextView=tableTextView;
}

-(UITextView*)getTableTextView
{
    return _tableTextView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [optionRows allKeys].count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option=[optionRows allKeysForObject:[NSNumber numberWithInteger:indexPath.row]].firstObject;
    return typeHeights[[optionTypes objectForKey:option].integerValue];
}

-(NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self updateSelectedOption];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedOption=[self optionForIndexPath:indexPath];
    NSNumber *type=[self typeForIndexPath:indexPath];
    NSString *option=[self optionForIndexPath:indexPath];
    if([type integerValue]>1)
    {
        if([_tableTextView canResignFirstResponder])
        {
            [_tableTextView endEditing:YES];
        }
    }
    if([type intValue]==2)
    {
        if(sliderShowing)
        {
            if([self indexPathForOption:child.option].row<indexPath.row)
            {
                [self sliderOverToOption:option right:YES];
            }
            else if([self indexPathForOption:child.option].row>indexPath.row)
            {
                [self sliderOverToOption:option right:NO];
            }
        }
        else
        {
            [self showSliderForOption:option];
        }
    }
    else
    {
        if(sliderShowing)
        {
            [self dismissSlider];
        }
        if([option isEqualToString:@"Go"])
        {
            [self goPressed];
        }
    }
    if([type intValue]==3)
    {
        [self updateOption:option withSelection:nil];
    }
    if([type intValue]==5)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self createFlyer];
        }];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableTextView endEditing:YES];
    if(addressSearchShowing)
    {
        [self resetSearchViewPosition];
    }
    
    
}

//Methods for Controlling Slider
-(void)setSliderDown
{
    CGRect field=_optionsTableView.frame;
    [_optionsTableView setFrame:CGRectMake(field.origin.x, field.origin.y, field.size.width, self.view.frame.size.height-field.origin.y)];
    [_slidingView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/sliderProportion)];
    sliderShowing=NO;
}

-(void)showSliderForOption:(NSString*)option
{
    sliderViewController *newSlider;
    if([option isEqualToString:@"Date"])
    {
        newSlider=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"dateSlider"];
    }
    else
    {
        newSlider=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"pickerSlider"];
    }
    child=newSlider;
    child.parent=self;
    [child configureForOption:option];
    [self addChildViewController:child];
    [_slidingView setAutoresizesSubviews:YES];
    [_slidingView addSubview:child.view];
    
    [_slidingView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/sliderProportion)];
    [child setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/sliderProportion)];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self slideUpBy:_slidingView.frame.size.height];
    }];
}

-(NSString*)nextSliderOption
{
    NSInteger start=[[optionRows objectForKey:_selectedOption] integerValue];
    for(NSInteger i=start+1; i<[optionRows allKeys].count; i++)
    {
        NSString *thisType=[[optionRows allKeysForObject:[NSNumber numberWithInteger:i]] firstObject];
        if([[optionTypes objectForKey:thisType] integerValue]==2)
        {
            return thisType;
        }
    }
    return _selectedOption;
}

-(void)print:(NSObject*)object
{
    //NSLog(@"%@",object);
}

-(NSString*)prevSliderOption
{
    NSInteger start=[[optionRows objectForKey:_selectedOption] integerValue];
    for(NSInteger i=start-1; i>0; i--)
    {
        NSString *thisType=[[optionRows allKeysForObject:[NSNumber numberWithInteger:i]] firstObject];
        if([[optionTypes objectForKey:thisType] integerValue]==2)
        {
            return thisType;
        }
    }
    return _selectedOption;
}

-(void)dismissSlider
{
    [self slideUpBy:-child.view.frame.size.height];
    [_optionsTableView deselectRowAtIndexPath:[_optionsTableView indexPathForSelectedRow] animated:YES];
}

-(void)slideUpBy:(CGFloat)height
{
    CGRect tableFrame=_optionsTableView.frame;
    CGRect sliderFrame=_slidingView.frame;
    CGRect newTable=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height-height);
    CGRect newSlider=CGRectMake(sliderFrame.origin.x, sliderFrame.origin.y-height, sliderFrame.size.width, sliderFrame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [_optionsTableView setFrame:newTable];
        [_slidingView setFrame:newSlider];
        [_optionsTableView scrollToRowAtIndexPath:[self indexPathForOption:_selectedOption] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        //[child.view setFrame:newSlider];
    } completion:^(BOOL finished){
        if(sliderShowing)
        {
            [child removeFromParentViewController];
            [child.view removeFromSuperview];
            sliderShowing=NO;
        }
        else
        {
            sliderShowing=YES;
        }
    }];
    
}

-(void)slideOverBy:(CGFloat)distance
{
    CGRect childFrame=child.view.frame;
    CGRect newChildFrame=newChild.view.frame;
    CGRect movedChildFrame=CGRectMake(childFrame.origin.x+distance, childFrame.origin.y, childFrame.size.width, childFrame.size.height);
    CGRect movedNewChildFrame=CGRectMake(newChildFrame.origin.x+distance, newChildFrame.origin.y, newChildFrame.size.width, newChildFrame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [child.view setFrame:movedChildFrame];
        [newChild.view setFrame:movedNewChildFrame];
    }completion:^(BOOL completed){
        [child removeFromParentViewController];
        [child.view removeFromSuperview];
        child=newChild;
    }];
    
}

-(void)sliderOverToOption:(NSString*)option right:(BOOL)right
{
    sliderViewController *newSlider;
    if([option isEqualToString:@"Date"])
    {
        newSlider=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"dateSlider"];
    }
    else
    {
        newSlider=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"pickerSlider"];
    }
    newChild=newSlider;
    newChild.parent=self;
    [newChild configureForOption:option];
    [self addChildViewController:newChild];
    [_slidingView addSubview:newChild.view];
    CGFloat factor=-1;
    if(right)
    {
        factor=1;
    }
    [newChild.view setFrame:CGRectMake(factor*_slidingView.frame.size.width, 0, _slidingView.frame.size.width, self.view.frame.size.height/sliderProportion)];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self slideOverBy:_slidingView.frame.size.width*-factor];
        [_optionsTableView selectRowAtIndexPath:[self indexPathForOption:option] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }];
}

-(void)slideToNextSliderOption
{
    NSString *oldSelection=_selectedOption;
    _selectedOption=[self nextSliderOption];
    if(![_selectedOption isEqualToString:oldSelection])
    {
        [self sliderOverToOption:_selectedOption right:YES];
        return;
    }
}

-(void)slideToPrevSliderOption
{
    NSString *oldSelection=_selectedOption;
    _selectedOption=[self prevSliderOption];
    if(![_selectedOption isEqualToString:oldSelection])
    {
        [self sliderOverToOption:_selectedOption right:NO];
        return;
    }
}

-(NSString*)lastSliderOption
{
    NSString *option;
    for(NSInteger i=optionRows.count-1; i>=0; i--)
    {
        option=[[optionRows allKeysForObject:[NSNumber numberWithInteger:i]] firstObject];
        if([[optionTypes objectForKey:option] integerValue]==2)
        {
            break;
        }
    }
    return option;
}

-(NSString*)firstSliderOption
{
    NSString *option;
    for(NSInteger i=0; i<[optionRows allKeys].count; i++)
    {
        option=[[optionRows allKeysForObject:[NSNumber numberWithInteger:i]] firstObject];
        if([[optionTypes objectForKey:option] integerValue]==2)
        {
            break;
        }
    }
    return option;
}

-(void)printCGRect:(CGRect)print
{
    //NSLog(@"x: %f, y: %f, width: %f, height: %f",print.origin.x,print.origin.y,print.size.width,print.size.height);
}

//Methods for retrieving type and option from index path

-(NSNumber*)typeForIndexPath:(NSIndexPath*)path
{
    return [optionTypes objectForKey:[self optionForIndexPath:path]];
}

-(NSString*)optionForIndexPath:(NSIndexPath*)path
{
    return [[optionRows allKeysForObject:[NSNumber numberWithInteger:path.row]] firstObject];
}

-(NSIndexPath*)indexPathForOption:(NSString*)option
{
    NSIndexPath *new=[NSIndexPath indexPathForRow:[[optionRows objectForKey:option] integerValue]  inSection:0];
    return new;
}

//Methods for Setting Individual Options
-(void)setTextOption:(NSString *)option
{
}

//Method to update options for creating event
-(void)updateOption:(NSString *)option withSelection:(id)selection
{
    if([option isEqualToString:@"Music"])
    {
        eventOptionsTextTableViewCell *temp=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:option]];
        [temp updateSelection:(NSString*)selection];
        _creation.music=(NSString*)selection;
        
    }
    else if([option isEqualToString:@"Venue"])
    {
        eventOptionsTextTableViewCell *temp=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:option]];
        [temp updateSelection:(NSString*)selection];
        _creation.venue=(NSString*)selection;
    }
    else if([[optionTypes objectForKey:option] integerValue]==3)
    {
        [self toggleOption:option];
    }
    else if([option isEqualToString:@"Date"])
    {
        eventOptionsTextTableViewCell *temp=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:option]];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        [format setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        [format setDateFormat:@"h:mm a, M/d"];
        NSString *updateWith=[format stringFromDate:(NSDate*)selection];
        [temp updateSelection:updateWith];
        _creation.date=(NSDate*)selection;
    }
    else if([option isEqualToString:@"Address"])
    {
        _creation.address=(NSString*)selection;
    }
    else if([option isEqualToString:@"Name"])
    {
        _creation.name=(NSString*)selection;
    }
    else if([option isEqualToString:@"About"])
    {
        _creation.about=(NSString*)selection;
    }
}

-(void)updateSelectedOption
{
    NSNumber *type=[optionTypes objectForKey:_selectedOption];
    if([type integerValue]==2)
    {
        [child prepareForSwitch];
    }
    else
    {
        
    }
}

-(void)toggleOption:(NSString*)option
{
    eventOptionsSwitchTableViewCell *temp=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:option]];
    [temp toggleSwitch];
    if([option isEqualToString:@"Private"])
    {
        if(temp.optionSwitch.isOn)
        {
            _creation.isPrivate=NO;
        }
        else
        {
            _creation.isPrivate=YES;
        }
    }
    else if([option isEqualToString:@"Free"])
    {
        if(temp.optionSwitch.isOn)
        {
            _creation.isFree=NO;
        }
        else
        {
            _creation.isFree=YES;
        }
        
    }
}

//Methods for displaying autocomplete results when entering an address
-(void)addressDidBeginEditing:(NSString*)address
{
    
    
}

-(void)addressDidChange:(NSString *)address
{
    if(!addressSearchShowing)
    {
        [self createSearchView];
    }
    else if([address isEqualToString:@""])
    {
        [self dismissSearchView];
    }
    [searchResultsChild searchForString:address];
}

-(void)addressDidEndEditing:(NSString *)address
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self dismissSearchView];
    }];
}

-(void)createSearchView
{
    searchResultsView=[[UIView alloc] init];
    CGRect textFrame=_tableTextView.frame;
    CGRect cellFrame=[self frameOfSelectedCell];
    cellFrame=CGRectMake(_optionsTableView.frame.origin.x+cellFrame.origin.x, _optionsTableView.frame.origin.y+cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    textFrame=CGRectMake(cellFrame.origin.x+textFrame.origin.x, cellFrame.origin.y+textFrame.origin.y, textFrame.size.width, textFrame.size.height);
    [self printCGRect:textFrame];
    [self printCGRect:cellFrame];
    CGFloat border=(cellFrame.size.width-textFrame.size.width)/2;
    CGFloat height=self.view.frame.size.height-keyboardFrame.size.height-textFrame.origin.y-textFrame.size.height-border;
    CGRect viewStartingFrame=CGRectMake(textFrame.origin.x, textFrame.origin.y+textFrame.size.height, textFrame.size.width, 0);
    CGRect viewEndingFrame=CGRectMake(viewStartingFrame.origin.x, viewStartingFrame.origin.y, viewStartingFrame.size.width, height);
    
    CGRect childViewStartingFrame=CGRectMake(0, 0, viewStartingFrame.size.width, viewStartingFrame.size.height);
    CGRect childViewEndingFrame=CGRectMake(0, 0, viewEndingFrame.size.width, viewEndingFrame.size.height);
    [self printCGRect:viewStartingFrame];
    [self printCGRect:viewEndingFrame];
    
    searchResultsChild=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"addressSearch"];
    searchResultsChild.parent=self;
    
    [self.view addSubview:searchResultsView];
    [searchResultsView setAutoresizesSubviews:YES];
    [searchResultsView setFrame:viewStartingFrame];
    [searchResultsChild setFrame:childViewStartingFrame];
    [self addChildViewController:searchResultsChild];
    [searchResultsView addSubview:searchResultsChild.view];
    [self.view bringSubviewToFront:searchResultsView];
    
    [UIView animateWithDuration:.25 animations:^{
        [searchResultsView setFrame:viewEndingFrame];
        [searchResultsChild setFrame:childViewEndingFrame];
    }];
    
    addressSearchShowing=YES;
}

-(void)dismissSearchView
{
    CGRect newViewFrame=searchResultsView.frame;
    newViewFrame.size.height=0;
    CGRect newChildViewFrame=searchResultsChild.view.frame;
    newChildViewFrame.size.height=0;
    //CGRect newViewFrame=CGRectMake(searchResultsView.frame.origin.x, searchResultsView.frame.origin.y, searchResultsView.frame.size.width, 0);
    //CGRect newChildViewFrame=CGRectMake(0, 0, searchResultsView.frame.size.width, searchResultsView.frame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        [searchResultsView setFrame:newViewFrame];
        [searchResultsChild setFrame:newChildViewFrame];
    } completion:^(BOOL finished){
        [searchResultsView removeFromSuperview];
        [searchResultsChild.view removeFromSuperview];
        [searchResultsChild removeFromParentViewController];
        addressSearchShowing=NO;
    }];
}

-(void)resetSearchViewPosition
{
    CGRect textFrame=_tableTextView.frame;
    CGRect selectedFrame=[self frameOfSelectedCell];
    textFrame=CGRectMake(textFrame.origin.x+selectedFrame.origin.x, textFrame.origin.y+selectedFrame.origin.y, textFrame.size.width, textFrame.size.height);
    [searchResultsView setFrame:CGRectMake(textFrame.origin.x, textFrame.origin.y+textFrame.size.height, searchResultsView.frame.size.width, searchResultsView.frame.size.height)];
}

-(CGRect)frameOfSelectedCell
{
    eventOptionTableViewCell *selectedCell=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:_selectedOption]];
    return selectedCell.frame;
}

-(void)completeAddressWithString:(NSString *)string
{
    [self updateOption:@"Address" withSelection:string];
    eventOptionsFieldTableViewCell *temp=[_optionsTableView cellForRowAtIndexPath:[self indexPathForOption:@"Address"]];
    [temp completeAddress:string];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self dismissSearchView];
    }];
}

//Method to handle touching of a text view
-(void)textViewTouched:(UITextView*)textView option:(NSString*)option
{
    [self setTableTextView:textView];
    [self tableView:_optionsTableView didSelectRowAtIndexPath:[self indexPathForOption:option]];
    
    /*
    [self setTableTextView:textView];
    _selectedOption=option;
    if(sliderShowing)
    {
        [self dismissSlider];
    }*/
}

//Methods to create callout box, telling the user to complete any fields left blank
-(NSArray<NSString*>*)determineUnSelectedOptions
{
    NSMutableArray<NSString*> *temp=[[NSMutableArray alloc] init];
    for(NSString *option in [optionRows allKeys])
    {
        if([[_creation objectForOption:option] isEqual:[initialStates objectForKey:option]])
        {
            if((![option isEqualToString:@"Private"])&(![option isEqualToString:@"Free"]))
            {
                [temp addObject:option];
            }
        }
    }
    return temp;
}

-(void)createCalloutForOptions:(NSArray<NSString *>*)options
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"alert" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [alert addAction:alertAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

-(void)goPressed
{
    NSArray<NSString*> *outstanding=[self determineUnSelectedOptions];
    [self printArray:outstanding];
    if(outstanding.count==0)
    {
        [_creation print];
    }
    else
    {
        [self createCalloutForOptions:outstanding];
    }
}

-(void)printArray:(NSArray*)array
{
    for(NSObject *ob in array)
    {
        //NSLog(@"%@",ob);
    }
}

//Handle segues
-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [super performSegueWithIdentifier:identifier sender:sender];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue
{
    
}

//Navigate to view controller to create flyer
-(void)createFlyer
{
    [_optionsTableView deselectRowAtIndexPath:[_optionsTableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"openImageOption" sender:self];
}

@end
