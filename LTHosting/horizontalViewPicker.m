//
//  horizontalViewPicker.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/24/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "horizontalViewPicker.h"
#import "commonUseFunctions.h"

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
    
    NSArray<UIView*>* managedViews;
    
    BOOL impliesSize;
    
    UIView *leftIndicationIndicator;
    UIView *rightIndicationIndicator;
    
    BOOL leftShowing;
    BOOL rightShowing;
    
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
    _showsSelection=YES;
    impliesSize=NO;
    leftIndicationIndicator=[[UIView alloc] init];
    leftIndicationIndicator.backgroundColor=[UIColor blackColor];
    leftIndicationIndicator.hidden=YES;
    leftShowing=NO;
    rightIndicationIndicator=[[UIView alloc] init];
    rightIndicationIndicator.backgroundColor=[UIColor blackColor];
    rightIndicationIndicator.hidden=YES;
    rightShowing=NO;
    
    void (^addShadowToLayer)(CALayer *layer)=^(CALayer *layer){
        [layer setShadowOpacity:0.9f];
        [layer setShadowColor:[UIColor blackColor].CGColor];
        [layer setShadowRadius:8.0f];
        layer.masksToBounds=NO;
    };
    addShadowToLayer(leftIndicationIndicator.layer);
    addShadowToLayer(rightIndicationIndicator.layer);
    [self addSubview:leftIndicationIndicator];
    [self addSubview:rightIndicationIndicator];
    return self;
}

-(id)init
{
    self=[self initWithFrame:CGRectMake(0, 0, 100, 100)];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    BOOL reload=frame.size.height!=self.frame.size.height;
    [super setFrame:frame];
    if(reload)
    {
        CGFloat height=frame.size.height-_margin*2-bottomCushion;
        if(height>0)
        {
            thumbnailSize=CGSizeMake((height-labelHeight)/heightWidthRatio, height-labelHeight);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self reloadData];
            } completion:^{
            }];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat indicatorWidth=12.0f;
    [leftIndicationIndicator setFrame:CGRectMake(self.contentOffset.x-indicatorWidth, 0, indicatorWidth, self.frame.size.height)];
    [rightIndicationIndicator setFrame:CGRectMake(self.contentOffset.x+self.frame.size.width, 0, indicatorWidth, self.frame.size.height)];
    
    [self bringSubviewToFront:leftIndicationIndicator];
    [self bringSubviewToFront:rightIndicationIndicator];
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
    selectionView=selected;
    [self addSubview:selectionView];
}

-(void)deselectSelected
{
    [selectionView removeFromSuperview];
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
        thumbnailSize=CGSizeMake((self.frame.size.height-labelHeight-_margin*2.0f)/heightWidthRatio, self.frame.size.height-labelHeight-_margin*2.0f);
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
    if(self.contentSize.width<self.frame.size.width)
    {
        [self centerViews];
    }
}

-(void)centerViews
{
    CGFloat total=self.frame.size.width-[_dataSource numberOfViews]*thumbnailSize.width;
    total/=[_dataSource numberOfViews]+1;
    NSArray<UIView*> *sortedSubviews=[[self subviews] sortedArrayUsingComparator:^NSComparisonResult(UIView *one, UIView *two){
        return one.frame.origin.x>two.frame.origin.x;
    }];
    for(NSInteger i=0; i<sortedSubviews.count; i++)
    {
        [sortedSubviews[i] setFrame:CGRectMake((total+thumbnailSize.width)*i+total, sortedSubviews[i].frame.origin.y, sortedSubviews[i].frame.size.width, sortedSubviews[i].frame.size.height)];
    }
    [self layoutIfNeeded];
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
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [self reset];
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
                [temp addObject:thisOne];
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
    managedViews=temp;
    [self setContentSize];
    [self layoutIfNeeded];
    if(self.showsSelection&&managedViews.count>0)
    {
        [self selectRowAtIndex:[self selectedIndex]];
    }
}

-(IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    UIView *view=tap.view;
    NSInteger index=[self indexForFrameOfView:view.frame];
    if(_showsSelection)
    {
        [self selectRowAtIndex:index];
    }
    [self scrollIndexToVisible:index animated:YES];
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
    return CGRectMake(viewFrame.origin.x, viewFrame.origin.y-labelHeight, viewFrame.size.width, labelHeight);
}

-(NSInteger)indexForFrameOfView:(CGRect)frame
{
    if(self.contentSize.width>=self.frame.size.width)
    {
        CGFloat num=(frame.origin.x-_margin)/(thumbnailSize.width+_margin);
        return round(num);
    }
    else
    {
        NSMutableArray<UIView*>* sorted=[NSMutableArray arrayWithArray:[managedViews sortedArrayUsingComparator:^NSComparisonResult(UIView *one, UIView *two){
            return one.frame.origin.x>two.frame.origin.x;
        }]];
        NSInteger index=0;
        while(index<sorted.count)
        {
            if(sorted[index].frame.origin.x>=frame.origin.x)
            {
                break;
            }
            index++;
        }
        return index;
    }
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
    managedViews=nil;
    [self addSubview:leftIndicationIndicator];
    [self addSubview:rightIndicationIndicator];
}

-(void)scrollIndexToVisible:(NSInteger)index animated:(BOOL)animated
{
    if(_dataSource==nil||index<0||index>=managedViews.count)
    {
        return;
    }
    CGRect frame=[self frameForViewAtIndex:index];
    [self scrollRectToVisible:CGRectMake(frame.origin.x-_margin, frame.origin.y, frame.size.width+_margin*2, frame.size.height) animated:animated];
}

-(void)setImpliesContentSize:(BOOL)impliesContentSize
{
    impliesSize=impliesContentSize;
    leftIndicationIndicator.hidden=!impliesSize;
    rightIndicationIndicator.hidden=!impliesSize;
    self.contentOffset=self.contentOffset;
}

-(BOOL)impliesContentSize
{
    return impliesSize;
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    if(contentOffset.x==0)
    {
        [self setView:leftIndicationIndicator showing:NO animated:YES completion:nil];
    }
    else{
        [self setView:leftIndicationIndicator showing:YES animated:YES completion:nil];
        if(contentOffset.x==self.contentSize.width-self.frame.size.width)
        {
            [self setView:rightIndicationIndicator showing:NO animated:YES completion:nil];
        }
        else
        {
            [self setView:rightIndicationIndicator showing:YES animated:YES completion:nil];
        }
    }
}

-(void)toggleShowing:(UIView*)view animated:(BOOL)animated completion:(void(^)())completionBlock
{
    CGFloat final=0;
    if(view.alpha==0)
    {
        final=1;
    }
    void (^actionBlock)()=^{
        view.alpha=final;
    };
    if(animated)
    {
        [UIView animateWithDuration:.25 animations:actionBlock completion:^(BOOL finished){
            if(completionBlock!=nil)
            {
                completionBlock();
            }
        }];
    }
    else
    {
        actionBlock();
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    }
}

-(void)setView:(UIView*)view showing:(BOOL)showing animated:(BOOL)animated completion:(void(^)())completionBlock
{
    BOOL current=YES;
    if(view.alpha==0)
    {
        current=NO;
    }
    if(current!=showing)
    {
        [self toggleShowing:view animated:animated completion:completionBlock];
    }
}

@end
