//
//  AboutViewController.c
//  ComTools
//
//  Created by Zonggao Jia on 2016-01-19.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#include "AboutViewController.h"
#import "utilities.h"
#import "constants.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadHTMLString:aboutMessage baseURL:nil];
    
    self.btnClose.backgroundColor = [Utilities colorFromHexString:grayColor];
    self.btnClose.layer.cornerRadius = 8;
}

- (IBAction)closePopup:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}
@end
