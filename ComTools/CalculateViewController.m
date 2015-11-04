//
//  SecondViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-10-31.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "CalculateViewController.h"

@interface CalculateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtTotal;
@property (weak, nonatomic) IBOutlet UISlider *sldTipRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTipAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTip1;
@property (weak, nonatomic) IBOutlet UILabel *lblTip2;
@property (weak, nonatomic) IBOutlet UILabel *lblTip3;
@property (weak, nonatomic) IBOutlet UILabel *lblTip4;
@property (weak, nonatomic) IBOutlet UILabel *lblTip5;
@property (weak, nonatomic) IBOutlet UILabel *lblTipRate;

@end

@implementation CalculateViewController
- (IBAction)TotalChanged:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    float total = [self.txtTotal.text floatValue];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblTipAmount.text = [NSString stringWithFormat:@"Tip is %@", [formatter stringFromNumber: [NSNumber numberWithFloat: (total * self.sldTipRate.value)]]];
    self.lblTip1.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.08f)]];
    self.lblTip2.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.1f)]];
    self.lblTip3.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.12f)]];
    self.lblTip4.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.15f)]];
    self.lblTip5.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.18f)]];
}

- (IBAction)RateChanged:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    float total = [self.txtTotal.text floatValue];
    self.lblTipRate.text = [NSString stringWithFormat:@"%.2f%%", self.sldTipRate.value * 100];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblTipAmount.text = [NSString stringWithFormat:@"Tip is %@", [formatter stringFromNumber: [NSNumber numberWithFloat: (total * self.sldTipRate.value)]]];
    self.lblTip1.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.08f)]];
    self.lblTip2.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.1f)]];
    self.lblTip3.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.12f)]];
    self.lblTip4.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.15f)]];
    self.lblTip5.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.18f)]];
}

//- CalculateTip

@end
