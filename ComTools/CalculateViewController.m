//
//  SecondViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-10-31.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "CalculateViewController.h"
#import "utilities.h"
#import "constants.h"
//#import "MemoManager.h"
#import "AppDelegate.h"

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
@property (weak, nonatomic) IBOutlet UIButton *btnTip1;
@property (weak, nonatomic) IBOutlet UIButton *btnTip2;
@property (weak, nonatomic) IBOutlet UIButton *btnTip3;
@property (weak, nonatomic) IBOutlet UIButton *btnTip4;
@property (weak, nonatomic) IBOutlet UIButton *btnTip5;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CalculateViewController {
    float total, tip, tipRate, totalAmount;
    NSNumberFormatter *calFormatter;
    AppDelegate *appDelegate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)btnTip1Tapped:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Tip Button 1" withValue:nil];
    [self.txtTotal endEditing:YES];
    [self.sldTipRate setValue:0.08];
    [self tipChanged:sender];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = 0.08;
}

- (IBAction)btnTip2Tapped:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Tip Button 2" withValue:nil];
    [self.txtTotal endEditing:YES];
    [self.sldTipRate setValue:0.10];
    [self tipChanged:sender];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = 0.10;
}

- (IBAction)btnTip3Tapped:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Tip Button 3" withValue:nil];
    [self.txtTotal endEditing:YES];
    [self.sldTipRate setValue:0.12];
    [self tipChanged:sender];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = 0.12;
}

- (IBAction)btnTip4Tapped:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Tip Button 4" withValue:nil];
    [self.txtTotal endEditing:YES];
    [self.sldTipRate setValue:0.15];
    [self tipChanged:sender];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = 0.15;
}

- (IBAction)btnTip5Tapped:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Tip Button 5" withValue:nil];
    [self.txtTotal endEditing:YES];
    [self.sldTipRate setValue:0.18];
    [self tipChanged:sender];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = 0.18;
}

- (IBAction)inputEnter:(id)sender {
    [sender selectAll:nil];
}

- (IBAction)totalChanged:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Calculate Input Amount" withValue:nil];

    total = [self.txtTotal.text floatValue];
    [self calTotalAndTip];
    
    //Update LocalMemo
    appDelegate.LocalMemo.totalAmount = total;
}

- (IBAction)tipChanged:(id)sender {
    [Utilities trackEvent:@"Slider changed" inCategory:@"Slider" withLabel:@"Calculate Tip Slider" withValue:nil];
    tipRate = self.sldTipRate.value;
    [self calTotalAndTip];
    
    //Update LocalMemo
    appDelegate.LocalMemo.tipPercentage = tipRate;
}

- (IBAction)endEditing:(id)sender {
    [self.txtTotal endEditing:YES];
}

- (void)calTotalAndTip {
    [self calTip];
    totalAmount = total + tip;
    self.lblTotalAmount.text = [NSString stringWithFormat:@"Total is %@", [calFormatter stringFromNumber: [NSNumber numberWithFloat: totalAmount]]];
    [self calAllTips];
    [self calGroupAmount];
}

- (void)calTip {
    tip = total * tipRate;
    self.lblTipRate.text = [NSString stringWithFormat:@"%.2f%%", tipRate * 100];
    self.lblTipAmount.text = [NSString stringWithFormat:@"Tip is %@", [calFormatter stringFromNumber: [NSNumber numberWithFloat: tip]]];
}

- (void)calAllTips {
    self.lblTip1.text = [calFormatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.08f)]];
    self.lblTip2.text = [calFormatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.1f)]];
    self.lblTip3.text = [calFormatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.12f)]];
    self.lblTip4.text = [calFormatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.15f)]];
    self.lblTip5.text = [calFormatter stringFromNumber: [NSNumber numberWithFloat: (total * 0.18f)]];
}

- (IBAction)groupSizeChanged:(id)sender {
    [Utilities trackEvent:@"Shortcut button pressed" inCategory:@"Button" withLabel:@"Calculate Group Size" withValue:nil];
    [self calGroupAmount];
    
    //Update LocalMemo
    appDelegate.LocalMemo.groupSize = self.stepGroupSize.value;
}

- (void)calGroupAmount {
    int groupSize = self.stepGroupSize.value;
    self.lblSplitAmount.text = [calFormatter stringFromNumber: [NSNumber numberWithDouble: totalAmount / groupSize]];
    
    self.lblGroupSize.text = [NSString stringWithFormat:@"%d", groupSize];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    calFormatter = [[NSNumberFormatter alloc] init];
    [calFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    //background
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //set styles
    self.btnTip1.layer.cornerRadius =
    self.btnTip2.layer.cornerRadius =
    self.btnTip3.layer.cornerRadius =
    self.btnTip4.layer.cornerRadius =
    self.btnTip5.layer.cornerRadius = 10;
    self.btnTip1.clipsToBounds =
    self.btnTip2.clipsToBounds =
    self.btnTip3.clipsToBounds =
    self.btnTip4.clipsToBounds =
    self.btnTip5.clipsToBounds = YES;
    self.btnTip1.backgroundColor =
    self.btnTip2.backgroundColor =
    self.btnTip3.backgroundColor =
    self.btnTip4.backgroundColor =
    self.btnTip5.backgroundColor = [Utilities colorFromHexString:themeColor];

    //scroll view
    if (IS_IPHONE_4) {
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setContentSize: CGSizeMake(320, 640)];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    //Load from LocalMemo
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.LocalMemo.tipPercentage) {
        tipRate = appDelegate.LocalMemo.tipPercentage;
        [self.sldTipRate setValue:tipRate];
        [self tipChanged:nil];
    } else
        tipRate = 0.1;
    
    if (appDelegate.LocalMemo.groupSize) {
        [self.stepGroupSize setValue:appDelegate.LocalMemo.groupSize];
        [self groupSizeChanged:nil];
    }
    
    if (appDelegate.LocalMemo.totalAmount) {
        self.txtTotal.text = [NSString stringWithFormat:@"%.02f", appDelegate.LocalMemo.totalAmount];
        [self totalChanged:nil];
    }
}

- (void)scrollViewSingleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utilities trackScreen:@"Calculate Tool"];
}
@end
