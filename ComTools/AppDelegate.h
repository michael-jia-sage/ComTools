//
//  AppDelegate.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-10-31.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "constants.h"
#include "utilities.h"
#import "localmemo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property localmemo *LocalMemo;

@end

