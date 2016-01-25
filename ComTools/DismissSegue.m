//
//  DismissSegue.c
//  ComTools
//
//  Created by Zonggao Jia on 2016-01-23.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end