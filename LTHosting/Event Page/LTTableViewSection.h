//
//  LTTableViewSection.h
//  LTEventPage
//
//  Created by Cam Feenstra on 3/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <RETableViewManager/RETableViewManager.h>

@interface RETableViewSection (extension)

-(void)deleteItem:(RETableViewItem*)item animated:(BOOL)animated completion:(void(^)())completionBlock;

@end
