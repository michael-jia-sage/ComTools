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
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UIStepper *stepGroupSize;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupSize;
@property (weak, nonatomic) IBOutlet UILabel *lblSplitAmount;

@end

@implementation CalculateViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)DoCalculate:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    float total = [self.txtTotal.text floatValue];
    float tipRate = self.sldTipRate.value;
    float tip = total * tipRate;
    self.lblTipRate.text = [NSString stringWithFormat:@"%.2f%%", tipRate * 100];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblTipAmount.text = [NSString stringWithFormat:@"Tip is %@", [formatter stringFromNumber: [NSNumber numberWithFloat: tip]]];
    self.lblTip1.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.08f)]];
    self.lblTip2.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.1f)]];
    self.lblTip3.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.12f)]];
    self.lblTip4.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.15f)]];
    self.lblTip5.text = [formatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.18f)]];
    
    float totalAmount = total + tip;
    self.lblTotalAmount.text = [NSString stringWithFormat:@"Total is %@", [formatter stringFromNumber: [NSNumber numberWithFloat: totalAmount]]];
    
    double groupSize = self.stepGroupSize.value;
    self.lblSplitAmount.text = [formatter stringFromNumber: [NSNumber numberWithDouble: totalAmount / groupSize]];
    
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    self.lblGroupSize.text = [formatter stringFromNumber: [NSNumber numberWithDouble: groupSize]];
}

@end
