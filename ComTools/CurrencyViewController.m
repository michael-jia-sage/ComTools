//
//  CurrencyViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "CurrencyViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"
#import "currency.h"
#import "utilities.h"

@interface CurrencyViewController () <CRCurrencyRequestDelegate>
@property (nonatomic) CRCurrencyRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UITableView *lstCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyName;
@property (weak, nonatomic) IBOutlet UILabel *lblUSD;

@end

@implementation CurrencyViewController
CRCurrencyResults *res;
double usdValue = 0;
double curRate = 1.00;
NSMutableArray *supportedCurrencies;
NSNumberFormatter *formatter;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [supportedCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    currency *cur = [supportedCurrencies objectAtIndex: indexPath.row];
    cell.textLabel.text = cur.name;
    cur.rate = [res _rateForCurrency:cur.code];
    double curValue = usdValue * cur.rate;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", curValue];
    
    UILabel *lblRate = [[UILabel alloc] init];// :CGRectMake(20,40,50,20)];
    lblRate.text =  [NSString stringWithFormat: @"1 USD = %.2f", cur.rate];
    lblRate.font=[UIFont fontWithName:@"AppleGothic" size:12];
    [cell.contentView addSubview:lblRate];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Tab to select";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currency *cur = [supportedCurrencies objectAtIndex: indexPath.row];
    curRate = cur.rate;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.lblCurrencyName.text = cell.textLabel.text;
    self.inputField.text = cell.detailTextLabel.text;
    self.lblUSD.text = [NSString stringWithFormat:@"Rate: %.2f   USD: %@", curRate, [formatter stringFromNumber: [NSNumber numberWithFloat: usdValue]]];
    self.lblUSD.hidden = [cell.textLabel.text isEqualToString:@"US Dollar"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblUSD.hidden = YES;
    
    //load supported currencies
    supportedCurrencies = [Utilities initCurrencies];
    
    self.inputField.text = @"100";
    [self buttonTapped:[self convertButton]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)buttonTapped:(id)sender {
    self.convertButton.enabled = NO;
    usdValue = [self.inputField.text floatValue];
    if (curRate != 1.00) {
        usdValue = usdValue / curRate;
    }
    self.lblUSD.text = [NSString stringWithFormat:@"Rate: %.2f   USD: %@", curRate, [formatter stringFromNumber: [NSNumber numberWithFloat: usdValue]]];
    self.req = [[CRCurrencyRequest alloc] init];
    
    self.req.delegate = self;
    [self.req start];
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    res = currencies;
    
    [self.lstCurrency reloadData];
    [self.inputField endEditing:YES];
    self.convertButton.enabled = YES;
}

@end
