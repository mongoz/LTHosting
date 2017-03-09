//
//  textToolView.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "textToolView.h"
#import "editorView.h"
#import "textEditingLayer.h"
#import "toolViewItem.h"

@interface textToolView(){
    textEditingLayer *target;
    NSArray<toolViewItem*>* items;
}

@end

@implementation textToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(NSArray<toolViewItem*>*)items
{
    if(items==nil)
    {
        NSMutableArray *objects=[[NSMutableArray alloc] init];
        [objects addObject:[[toolViewItem alloc] initWithSkew:colorPickerTool target:target toolType:self.type]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:shadePickerTool target:target toolType:self.type]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:sizePickerTool target:target toolType:self.type]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:fontPickerTool target:target toolType:self.type]];
        [objects addObject:[[toolViewItem alloc] initWithSkew:alignmentTool target:target toolType:self.type]];
        items=objects;
    }
    return items;
}

-(void)setType:(toolType)type
{
    [super setType:type];
    switch (self.myType) {
        case bodyTextTool:
            target=[[editorView shared] bodyLayer];
            break;
        case titleTextTool:
            target=[[editorView shared] titleLayer];
            break;
        default:
            break;
    }
    items=nil;
    [self.toolPicker reloadData];
}

@end
