//
//  horizontalViewPicker.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "horizontalViewPicker.h"

@interface horizontalViewPicker(){
    CGSize thumbnailSize;
    
    CGPoint previousContentOffset;
    
    
}
@end

@implementation horizontalViewPicker

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    _margin=6.0f;
    CGFloat height=frame.size.height-_margin*2;
    thumbnailSize=CGSizeMake(height, height);
    [self setShowsVerticalScrollIndicator:NO];
    _dataSource=nil;
    _hDelegate=nil;
    previousContentOffset=CGPointZero;
    [self setContentSize:CGSizeMake(CGFLOAT_MAX,frame.size.height)];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setDataSource:(id<horizontalViewPickerDataSource>)dataSource
{
    _dataSource=dataSource;
    [self reloadData];
    [self setContentSize:CGSizeMake(_margin+(_margin+thumbnailSize.width)*[_dataSource numberOfViews], self.frame.size.height)];
}

-(void)setHDelegate:(id<horizontalViewPickerDelegate>)delegate
{
    _hDelegate=delegate;
}

-(void)reloadData
{
    if(_dataSource==nil)
    {
        return;
    }
    for(NSInteger i=0; i<[_dataSource numberOfViews]; i++)
    {
        CGRect thisRect=[self frameForViewAtIndex:i];
        UIView *thisOne=[_dataSource viewForIndex:i];
        //thisOne=[self placeHolderViewInRect:thisOne.frame];
        if([self rectIsOnScreen:thisRect])
        {
            if(![self.subviews containsObject:thisOne])
            {
                [thisOne setFrame:thisRect];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                [thisOne addGestureRecognizer:tap];
                [self addSubview:thisOne];
            }
        }
        else
        {
            if([self.subviews containsObject:thisOne])
            {
                [thisOne removeFromSuperview];
            }
        }
    }
    [self layoutIfNeeded];
}

-(IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    NSLog(@"tapped");
    UIView *view=tap.view;
    NSInteger index=[self indexForFrameOfView:view.frame];
    if(_hDelegate!=nil)
    {
        [_hDelegate horizontalPickerDidSelectViewAtIndex:index];
    }
}

-(BOOL)rectIsOnScreen:(CGRect)rect
{
    if(rect.origin.x+rect.size.width>=-self.contentOffset.x)
    {
        return YES;
    }
    return NO;
}

-(UIView*)placeHolderViewInRect:(CGRect)rect
{
    UIView *temp=[[UIView alloc] initWithFrame:rect];
    [temp setBackgroundColor:[UIColor lightGrayColor]];
    return temp;
}

-(CGRect)frameForViewAtIndex:(NSInteger)index
{
    return CGRectMake(_margin+(thumbnailSize.width+_margin)*index, _margin, thumbnailSize.width, thumbnailSize.height);
}

-(NSInteger)indexForFrameOfView:(CGRect)frame
{
    CGFloat num=(frame.origin.x-_margin)/(thumbnailSize.width+_margin);
    return round(num);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self reloadData];
    previousContentOffset=self.contentOffset;
}

@end
