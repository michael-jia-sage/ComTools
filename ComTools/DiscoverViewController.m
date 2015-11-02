//
//  DiscoverViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface DiscoverViewController ()
@property (nonatomic) DGDistanceRequest *req;

@property (weak, nonatomic) IBOutlet UITextField *inputLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSelector;
@property (weak, nonatomic) IBOutlet UILabel *toVancouverLbl;
@property (weak, nonatomic) IBOutlet UILabel *toNewYorkLbl;
@property (weak, nonatomic) IBOutlet UIButton *calBtn;

@end

@implementation DiscoverViewController
- (IBAction)calBtnTapped:(id)sender {
    self.calBtn.enabled = NO;
    self.req = [DGDistanceRequest alloc];
    
    NSString *start = self.inputLocation.text;
    NSString *destA = @"Vancouver";
    NSArray *dests = @[destA];
    
    self.req = [self.req initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak DiscoverViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray *responses) {
        DiscoverViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSNull *badRequest = [NSNull null];
        double factor = 0;
        NSString *unit;
        if (strongSelf.unitSelector.selectedSegmentIndex == 0) {
            factor = 1.0;
            unit = @"Meter";
        } else if (strongSelf.unitSelector.selectedSegmentIndex == 1) {
            factor = 1000.0;
            unit = @"KM";
        } else {
            factor = 1609.344;
            unit = @"Miles";
        }
        
        if (responses[0] != badRequest) {
            double num = [responses[0] floatValue]/factor;
            NSString *x = [NSString stringWithFormat:@"%.2f %@", num, unit];
            strongSelf.toVancouverLbl.text = x;
        } else {
            strongSelf.toVancouverLbl.text = @"Error";
        }
        
        strongSelf.req = nil;
        strongSelf.calBtn.enabled = YES;
    };
    
    [self.req start];
}
@end
