//
//  fontTool.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/2/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "fontTool.h"
#import "usefulArray.h"
#import "textEditingLayer.h"
#import "toolView.h"
#import "editorView.h"

@interface fontTool(){
    horizontalViewPicker *scroller;
    CGFloat margin;
}

@end

@implementation fontTool

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static NSInteger bodyIndex=0;
static NSInteger titleIndex=0;

+(NSInteger)bodyIndex
{
    return bodyIndex;
}

+(NSInteger)titleIndex
{
    return titleIndex;
}


-(id)init
{
    self=[super init];
    margin=12;

    scroller=[[horizontalViewPicker alloc] init];
    scroller.bounces=NO;
    [scroller setHeightWidthRatio:640.0f/480.0f];
    [scroller setLabelTextColor:[UIColor blackColor]];
    scroller.hDelegate=self;
    scroller.dataSource=self;
    [scroller selectRowAtIndex:0];
    [self addSubview:scroller];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [scroller setFrame:self.bounds];
}

-(CGRect)frameForIndex:(NSInteger)index
{
    CGFloat height=self.frame.size.height-margin*2;
    CGSize size=CGSizeMake(height/scroller.heightWidthRatio, height);
    return CGRectMake(margin*(index+1)+size.width*index, margin, size.width, size.height);
}

-(void)setTargetLayer:(editingLayer *)targetLayer
{
    [super setTargetLayer:targetLayer];
    [scroller reloadData];
    NSInteger t=[self selectedIndex];
    NSLog(@"selected: %ld",(long)t);
    [scroller selectRowAtIndex:t];
}

-(void)updateCurrentValueAnimated:(BOOL)animated
{
    [super updateCurrentValueAnimated:animated];
    [scroller selectRowAtIndex:[self selectedIndex]];
}


-(CGRect)visibleFrame
{
    return CGRectMake(scroller.contentOffset.x, scroller.contentOffset.y, scroller.frame.size.width, scroller.frame.size.height);
}

//Horizontal picker view
-(UIView*)viewForIndex:(NSInteger)index
{
    UIFont *thisFont=[self currentFontsWithSize:72.0f][index];
    return [self viewForFont:thisFont];    
}

-(UIView*)viewForFont:(UIFont*)font
{
    UILabel *label=[[UILabel alloc] init];
    label.text=@"A";
    label.font=font;
    label.adjustsFontSizeToFitWidth=YES;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.backgroundColor=[UIColor grayColor];
    label.textColor=[UIColor whiteColor];
    label.layer.cornerRadius=16.0f;
    label.layer.masksToBounds=YES;
    return label;
}

-(NSInteger)numberOfViews
{
    return [self currentFontNames].count;
}

-(BOOL)shouldUseLabels
{
    return YES;
}

-(NSString*)labelForIndex:(NSInteger)index
{
    return [self currentFontNames][index];
}

-(NSArray<NSString*>*)currentFontNames{
    if([self title]){
        return [usefulArray titleFontPostScriptNames];
    }
    return [usefulArray bodyFontPostScriptNames];
}

-(NSArray<UIFont*>*)currentFontsWithSize:(CGFloat)size{
    if([self title]){
        return [usefulArray titleFontsWithSize:size];
    }
    return [usefulArray bodyFontsWithSize:size];
}

-(BOOL)shouldHandleViewResizing
{
    return YES;
}

-(UIView*)view:(UIView *)view inFrame:(CGRect)frame
{
    [view setFrame:frame];
    for(UIView *vi in view.subviews)
    {
        [vi setFrame:view.bounds];
    }
    return view;
}

-(void)horizontalPickerDidSelectViewAtIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
    [(textEditingLayer*)self.targetLayer setFont:[self currentFontsWithSize:[(textEditingLayer*)self.targetLayer font].pointSize][index]];
    if(self.toolDelegate!=nil&&[self.toolDelegate respondsToSelector:@selector(toolValueChanged:)])
    {
        [self.toolDelegate toolValueChanged:self];
    }
}

+(void)setBodyIndex:(NSInteger)index
{
    bodyIndex=index;
}

+(void)setTitleIndex:(NSInteger)index
{
    titleIndex=index;
}

-(NSInteger*)sIndex
{
    if(self.targetLayer==nil)
    {
        return nil;
    }
    if(self.targetLayer==[[editorView shared] bodyLayer])
    {
        return &bodyIndex;
    }
    else
    {
        return &titleIndex;
    }
}

-(BOOL)title{
    if(self.targetLayer==nil){
        return NO;
    }
    if(self.targetLayer==[[editorView shared] bodyLayer]) {
        return NO;
    }
    return YES;
}

-(NSInteger)selectedIndex
{
    if([self sIndex]==nil)
    {
        return 0;
    }
    return *[self sIndex];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    *[self sIndex]=selectedIndex;
}

-(void)dissolveIn:(BOOL)ind completion:(void (^)())completionBlock
{
    [scroller scrollIndexToVisible:[self selectedIndex] animated:NO];
    [super dissolveIn:ind completion:completionBlock];
}
@end
