//
//  borderToolView.m
//  flyerCreator
//
//  Created by Cam Feenstra on 2/23/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "borderToolView.h"
#import "borderPicker.h"
#import "editorView.h"

@interface borderToolView(){
    
}

@end

@implementation borderToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self=[super init];
    [self checkForBorder];
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

NSArray<toolViewItem*>* items=nil;

-(NSArray<toolViewItem*>*)items
{
    if(items==nil)
    {
        NSMutableArray *objects=[[NSMutableArray alloc] init];
        [objects addObject:[[toolViewItem alloc] initWithSkew:borderPickerTool target:[[editorView shared] borderLayer] toolType:borderTool]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:tintTool target:[[editorView shared] backgroundTintLayer] toolType:borderTool]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:colorPickerTool target:[[editorView shared] borderLayer] toolType:borderTool]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:shadePickerTool target:[[editorView shared] borderLayer] toolType:borderTool]];
        for(toolViewItem *t in self.subviews)
        {
            [t setFrame:CGRectMake(0, 0, self.frame.size.height/self.toolPicker.heightWidthRatio, self.frame.size.height)];
        }
        items=objects;
    }
    return items;
}


-(void)checkForBorder
{
    BOOL shouldbe=[[[editorView shared] borderLayer] mask]!=nil||[[[editorView shared] borderLayer] contents]!=nil;
    if(!shouldbe)
    {
        [borderPicker setSelectedIndex:0];
    }
    for(NSInteger i=2; i<[self items].count; i++)
    {
        [self items][i].selectable=shouldbe;
    }
}

-(void)endUsingTool
{
    [self checkForBorder];
    [super endUsingTool];
}

-(void)willAppear
{
    [super willAppear];
    [self checkForBorder];
}

-(void)willDisappear
{
    [super willDisappear];
    
}
@end
