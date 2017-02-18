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
    
    CGFloat labelHeight;
    
    UIColor *labelTextColor;
    UIFont *labelFont;
    
    CGFloat heightWidthRatio;
    
    CGFloat labelSizeProp;
    
    CGFloat bottomCushion;
    
    NSInteger selectedIndex;
    
    UIView *selectionView;
    
}
@end

@implementation horizontalViewPicker

-(id)initWithFrame:(CGRect)frame
{
    selectionView=nil;
    self=[super initWithFrame:frame];
    bottomCushion=2;
    labelSizeProp=1.25;
    heightWidthRatio=1.0f;
    selectedIndex=-1;
    labelHeight=0;
    _margin=8.0f;
    CGFloat height=frame.size.height-_margin*2-bottomCushion;
    thumbnailSize=CGSizeMake(height, height/heightWidthRatio);
    [self setShowsVerticalScrollIndicator:NO];
    _dataSource=nil;
    _hDelegate=nil;
    previousContentOffset=CGPointZero;
    [self setContentSize:CGSizeMake(CGFLOAT_MAX,frame.size.height)];
    labelTextColor=[UIColor whiteColor];
    labelFont=[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    return self;
}



-(NSInteger)selectedIndex
{
    return selectedIndex;
}

-(void)selectRowAtIndex:(NSInteger)index
{
    if(selectedIndex!=-1)
    {
        [self deselectSelected];
    }
    selectedIndex=index;
    [self selectViewInRect:[self frameForViewAtIndex:index]];
}

-(void)selectViewInRect:(CGRect)frame
{
    UIView *selected=[[UIView alloc] initWithFrame:CGRectMake(frame.origin.x-_margin/2, frame.origin.y-_margin/2-labelHeight, frame.size.width+_margin, frame.size.height+_margin+labelHeight)];
    [selected setBackgroundColor:[UIColor blueColor]];
    [selected setAlpha:.25];
    [selected addObserver:self forKeyPath:@"superview" options:NSKeyValueObservingOptionNew context:nil];
    selectionView=selected;
    [self addSubview:selectionView];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"blah");
}

-(void)deselectSelected
{
    [selectionView removeFromSuperview];
    [selectionView removeObserver:self forKeyPath:@"superview"];
    selectionView=nil;
    selectedIndex=-1;
}

-(void)setMargin:(CGFloat)margin
{
    _margin=margin;
    [self reloadData];
}

-(UIColor*)labelTextColor
{
    return labelTextColor;
}

-(void)setLabelTextColor:(UIColor*)color
{
    labelTextColor=color;
    if(_dataSource!=nil)
    {
        if([_dataSource shouldUseLabels])
        {
            [self reloadData];
        }
    }
}

-(UIFont*)labelFont
{
    return labelFont;
}

-(void)setLabelFont:(UIFont *)font
{
    labelFont=font;
    if(labelHeight!=0)
    {
        labelHeight=font.lineHeight*labelSizeProp;
    }
    if(_dataSource!=nil)
    {
        if([_dataSource shouldUseLabels])
        {
            [self reloadData];
        }
    }
}

-(CGFloat)heightWidthRatio
{
    return heightWidthRatio;
}

-(void)setHeightWidthRatio:(CGFloat)ratio
{
    heightWidthRatio=ratio;
    thumbnailSize=CGSizeMake(thumbnailSize.height/heightWidthRatio, thumbnailSize.height);
    [self reloadData];
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
    if([dataSource shouldUseLabels])
    {
        labelHeight=labelFont.lineHeight*labelSizeProp;
        thumbnailSize=CGSizeMake((thumbnailSize.height-labelHeight)/heightWidthRatio, thumbnailSize.height-labelHeight);
    }
    else
    {
        labelHeight=0;
        thumbnailSize=CGSizeMake((self.frame.size.height-_margin*2)/heightWidthRatio, (self.frame.size.height-_margin*2));
    }
    [self reloadData];
}

-(void)setContentSize
{
    if(_dataSource==nil)
    {
        return;
    }
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
    [self reset];
    [self setContentSize];
    for(NSInteger i=0; i<[_dataSource numberOfViews]; i++)
    {
        CGRect thisRect=[self frameForViewAtIndex:i];
        UIView *thisOne=[_dataSource viewForIndex:i];
        //thisOne=[self placeHolderViewInRect:thisOne.frame];
        if([self rectIsOnScreen:thisRect])
        {
            if(![self.subviews containsObject:thisOne])
            {
                if([self.hDelegate shouldHandleViewResizing])
                {
                    thisOne=[_hDelegate view:thisOne inFrame:thisRect];
                }
                else
                {
                    [thisOne setFrame:thisRect];
                }
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                [thisOne addGestureRecognizer:tap];
                [thisOne setUserInteractionEnabled:YES];
                [self addSubview:thisOne];
                if([_dataSource shouldUseLabels])
                {
                    UILabel *lab=[[UILabel alloc] initWithFrame:[self frameForLabelAtIndex:i]];
                    [lab setText:[_dataSource labelForIndex:i]];
                    [lab setTextAlignment:NSTextAlignmentCenter];
                    [lab setFont:labelFont];
                    [lab setTextColor:labelTextColor];
                    [lab sizeToFit];
                    [lab setFrame:CGRectMake(lab.frame.origin.x, lab.frame.origin.y, [self frameForLabelAtIndex:i].size.width, lab.frame.size.height)];
                    [self addSubview:lab];
                }
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
    if(selectionView!=nil)
    {
        [self addSubview:selectionView];
    }
    [self layoutIfNeeded];
}

-(IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    UIView *view=tap.view;
    NSInteger index=[self indexForFrameOfView:view.frame];
    [self selectRowAtIndex:index];
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
    
    return CGRectMake(_margin+((thumbnailSize.width)+_margin)*index, _margin+labelHeight, thumbnailSize.width, thumbnailSize.height);
}

-(CGRect)frameForLabelAtIndex:(NSInteger)index
{
    CGRect viewFrame=[self frameForViewAtIndex:index];
    return CGRectMake(viewFrame.origin.x, viewFrame.origin.y-labelHeight, viewFrame.size.width, labelFont.pointSize);
}

-(NSInteger)indexForFrameOfView:(CGRect)frame
{
    CGFloat num=(frame.origin.x-_margin)/(thumbnailSize.width+_margin);
    return round(num);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    previousContentOffset=self.contentOffset;
}

-(UIView*)subViewInRect:(CGRect)rect
{
    for(UIView *view in self.subviews)
    {
        if(view.frame.origin.x==rect.origin.x&&view.frame.origin.y==rect.origin.y&&view.frame.size.width==rect.size.width&&view.frame.size.height==rect.size.height)
        {
            return view;
        }
    }
    return nil;
}

-(UIView*)subViewAtIndex:(NSInteger)index
{
    return [self subViewInRect:[self frameForViewAtIndex:index]];
}

-(void)reset
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

@end
