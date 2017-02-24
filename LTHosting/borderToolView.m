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
#import "borderEditingLayer.h"

@interface borderToolView(){
    borderPicker *picker;
    
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
        [objects addObject:[[toolViewItem alloc] initWithSkew:borderPickerTool target:[[editorView shared] borderLayer] toolView:self]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:colorPickerTool target:[[editorView shared] borderLayer] toolView:self]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:shadePickerTool target:[[editorView shared] borderLayer] toolView:self]];
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
    BOOL shouldbe=[borderPicker selectedIndex]!=0;
    for(NSInteger i=1; i<[self items].count; i++)
    {
        [self items][i].selectable=shouldbe;
    }
}

-(void)endUsingTool
{
    [self checkForBorder];
    [super endUsingTool];
}
@end
