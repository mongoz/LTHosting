//
//  LTTableViewSection.m
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "LTTableViewSection.h"

@implementation RETableViewSection (extension)

-(void)deleteItem:(RETableViewItem *)item animated:(BOOL)animated completion:(void (^)())completionBlock
{
    void (^complete)()=^{
        if(completionBlock!=nil)
        {
            completionBlock();
        }
    };
    UITableView *tv=self.tableViewManager.tableView;
    if(tv==nil)
    {
        complete();
        return;
    }
    if(![self.items containsObject:item])
    {
        complete();
        return;
    }
    if(animated)
    {
        [tv beginUpdates];
        [tv deleteRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self removeItem:item];
        [tv endUpdates];
        complete();
    }
    else
    {
        [self removeItem:item];
        [tv reloadData];
        complete();
    }
    
}

@end
