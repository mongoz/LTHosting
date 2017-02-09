//
//  textToolViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "toolKitViewController.h"

typedef enum textToolType{
    bodyTextToolViewController,
    titleTextToolViewController
}textToolViewControllerType;

@interface textToolViewController : toolKitViewController

-(id)initWithType:(textToolViewControllerType)type;

@property (readonly) textToolViewControllerType type;

@end
