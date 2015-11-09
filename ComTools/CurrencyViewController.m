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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[CRCurrencyResults supportedCurrencies] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *cur = [[[CRCurrencyResults supportedCurrencies] allObjects] objectAtIndex:indexPath.row];
    cell.textLabel.text = [CRCurrencyResults _nameForCurrency:cur];
    
    double curValue = usdValue * [res _rateForCurrency:cur];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", curValue];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Tab to select";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cur = [[[CRCurrencyResults supportedCurrencies] allObjects] objectAtIndex:indexPath.row];
    curRate = [res _rateForCurrency:cur];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.lblCurrencyName.text = cell.textLabel.text;
    self.inputField.text = cell.detailTextLabel.text;
    self.lblUSD.hidden = [cell.textLabel.text isEqualToString:@"US Dollar"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblUSD.hidden = YES;
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblUSD.text = [NSString stringWithFormat:@"USD: %@", [formatter stringFromNumber: [NSNumber numberWithFloat: usdValue]]];
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
