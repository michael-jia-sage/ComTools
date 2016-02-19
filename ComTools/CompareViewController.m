//
//  CompareViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "CompareViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"
#import "constants.h"
#import "utilities.h"
#import "currency.h"
#import "AppDelegate.h"

@interface CompareViewController ()<CRCurrencyRequestDelegate>
@property (nonatomic) CRCurrencyRequest *cReq;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segOptions;
@property (weak, nonatomic) IBOutlet UILabel *lblFormat;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit1;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit2;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit1;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit2;
@property (weak, nonatomic) IBOutlet UISlider *slideUnit1;
@property (weak, nonatomic) IBOutlet UISlider *slideUnit2;

@end

@implementation CompareViewController {
    int option, inputIndex;
    float usd_rate, convert_rate;
    NSString *format;
    bool cadUpdated;
    NSMutableArray *cSupportedCurrencies;
    AppDelegate *appDelegate;
}


-(void)viewDidAppear:(BOOL)animated{
    [self UpdateCurrencies];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //background
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //initialize
    option = 0;
    inputIndex = 1;
    usd_rate = 1;
    convert_rate = 3.78541;
    format = @"%0.2f";
    cadUpdated = NO;
    
    //Load LocalMemo
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.LocalMemo.compareType)
        self.segOptions.selectedSegmentIndex = appDelegate.LocalMemo.compareType;
    if (appDelegate.LocalMemo.compareValue1)
        self.inputUnit1.text = [NSString stringWithFormat:@"%f", appDelegate.LocalMemo.compareValue1];
    
    //load supported currencies
    cSupportedCurrencies = [Utilities initCurrencies];
    [self UpdateCurrencies];
    [self segValueChanged: nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)segValueChanged:(id)sender {
    inputIndex = 1;
    option = (int)self.segOptions.selectedSegmentIndex;
    
    [Utilities trackEvent:@"Segment value changed" inCategory:@"Segment" withLabel:@"Compare Segment" withValue:[NSNumber numberWithInteger: option]];
    
    if (option == 1) {
        format = @"%0.1f";
        self.lblFormat.text = temperature_format;
        self.lblUnit1.text = @"\u00B0c";
        self.lblUnit2.text = @"\u00B0f";
        [self.slideUnit1 setMinimumValue:-20];
        [self.slideUnit1 setMaximumValue:50];
        [self.slideUnit2 setMinimumValue:-4];
        [self.slideUnit2 setMaximumValue:122];
        //self.inputUnit1.text = @"0";
        [self doCompare];
        [self setSlider];
    } else {
        format = @"%0.2f";
        self.lblFormat.text = [NSString stringWithFormat: gas_price_format, usd_rate];
        self.lblUnit1.text = @"ca$/liter";
        self.lblUnit2.text = @"us$/gal";
        [self.slideUnit1 setMinimumValue:0];
        [self.slideUnit1 setMaximumValue:2.00];
        [self.slideUnit2 setMinimumValue:0];
        [self.slideUnit2 setMaximumValue:2.00*convert_rate/usd_rate];
        //self.inputUnit1.text = @"1.00";
        [self doCompare];
        [self setSlider];
    }
    
    //Update LocalMemo
    appDelegate.LocalMemo.compareType = option;
}

- (IBAction)input1Changed:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Compare Input Unit 1" withValue:nil];
    inputIndex = 1;
    [self doCompare];
    [self setSlider];
}

- (IBAction)input2Changed:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Compare Input Unit 2" withValue:nil];
    inputIndex = 2;
    [self doCompare];
    [self setSlider];
}

- (IBAction)slide1Changed:(id)sender {
    [Utilities trackEvent:@"Slider changed" inCategory:@"Slider" withLabel:@"Compare Slider Unit 1" withValue:nil];
    inputIndex = 1;
    self.inputUnit1.text = [NSString stringWithFormat:format, self.slideUnit1.value];
    [self doCompare];
    [self setSlider];
}

- (IBAction)slide2Changed:(id)sender {
    [Utilities trackEvent:@"Slider changed" inCategory:@"Slider" withLabel:@"Compare Slider Unit 2" withValue:nil];
    inputIndex = 2;
    self.inputUnit2.text = [NSString stringWithFormat:format, self.slideUnit2.value];
    [self doCompare];
    [self setSlider];
}

- (IBAction)inputEnter:(id)sender {
    [sender selectAll:nil];
}

- (void)doCompare {
    if (option == 1) {
        if (inputIndex == 1) {
            //C to F
            float input1 = [self.inputUnit1.text floatValue];
            float input2 = input1 * 1.8 + 32;
            self.inputUnit2.text = [NSString stringWithFormat:format, input2];
        } else {
            //F to C
            float input2 = [self.inputUnit2.text floatValue];
            float input1 = (input2 - 32) * 5 / 9;
            self.inputUnit1.text = [NSString stringWithFormat:format, input1];
        }
    } else {
        if (inputIndex == 1) {
            //Cad to Usd
            float input1 = [self.inputUnit1.text floatValue];
            float input2 = input1 * convert_rate / usd_rate;
            self.inputUnit2.text = [NSString stringWithFormat:format, input2];
        } else {
            //Usd to Cad
            float input2 = [self.inputUnit2.text floatValue];
            float input1 = input2 * usd_rate / convert_rate;
            self.inputUnit1.text = [NSString stringWithFormat:format, input1];
        }
    }
    
    //Update LocalMemo
    appDelegate.LocalMemo.compareValue1 = [self.inputUnit1.text floatValue];
    
}

- (void)setSlider {
    float input1 = [self.inputUnit1.text floatValue];
    if (input1 < self.slideUnit1.minimumValue)
        input1 = self.slideUnit1.minimumValue;
    else if (input1 > self.slideUnit1.maximumValue)
        input1 = self.slideUnit1.maximumValue;
    [self.slideUnit1 setValue:input1];
    float input2 = [self.inputUnit2.text floatValue];
    if (input2 < self.slideUnit2.minimumValue)
        input2 = self.slideUnit2.minimumValue;
    else if (input2 > self.slideUnit2.maximumValue)
        input2 = self.slideUnit2.maximumValue;
    [self.slideUnit2 setValue:input2];
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    [Utilities updateDBCurrencies:currencies supportedCurrencies:cSupportedCurrencies];
    cadUpdated = YES;
    [self LoadLocalCurrencies];
}

-(void)UpdateCurrencies {
    if (cadUpdated)
        return;
    
    if ([Utilities InternetConnected]) {
        self.cReq = [[CRCurrencyRequest alloc] init];
        self.cReq.delegate = self;
        [self.cReq start];
    } else {
        cadUpdated = NO;
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"No Internet"
                                      message:@"No Internet, the CAD currency rate is loaded from local"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self LoadLocalCurrencies];
    }
}

-(void)LoadLocalCurrencies {
    cSupportedCurrencies = [Utilities loadCurrencyRatesFromLocal:cSupportedCurrencies];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", @"CAD"];
    NSArray *filteredArray = [cSupportedCurrencies filteredArrayUsingPredicate:predicate];
    currency *cur = [filteredArray objectAtIndex:0];
    usd_rate = cur.rate;
    [self segValueChanged: nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utilities trackScreen:@"Compare Tool"];
}
@end
