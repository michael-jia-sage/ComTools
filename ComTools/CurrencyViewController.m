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
#import "constants.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface CurrencyViewController () <CRCurrencyRequestDelegate>
@property (nonatomic) CRCurrencyRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *lstCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyName;
@property (weak, nonatomic) IBOutlet UILabel *lblUSD;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@end

@implementation CurrencyViewController {
    double usdValue;
    NSMutableArray *supportedCurrencies;
    currency *selCurrency;
    NSNumberFormatter *curFormatter;
    bool currencyUpdated;
    AppDelegate *appDelegate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [supportedCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    currency *cur = [supportedCurrencies objectAtIndex: indexPath.row];
    cell.textLabel.text = cur.name;
    double curValue = usdValue * cur.rate;
    if ([selCurrency.code isEqualToString:cur.code]) {
        curValue = [self.inputField.text floatValue];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", curValue];
    cell.textLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",cell.textLabel.font.fontName] size:cell.textLabel.font.pointSize];
    cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Utilities trackEvent:@"PickerView selected" inCategory:@"PickerView" withLabel:@"Currency Picker" withValue:[NSNumber numberWithInteger: indexPath.row]];
    selCurrency = [supportedCurrencies objectAtIndex: indexPath.row];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.lblCurrencyName.text = cell.textLabel.text;
    self.lblUSD.hidden = [cell.textLabel.text isEqualToString:@"US Dollar"];
    self.inputField.text = cell.detailTextLabel.text;
    self.btnReset.hidden = ([self.inputField.text floatValue] == 100);
    
    [self showCurrencyRate];
    
    //Update LocalMemo
    appDelegate.LocalMemo.curr = selCurrency;
    appDelegate.LocalMemo.currAmount = [self.inputField.text floatValue];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.inputField.editing) {
        [self.inputField endEditing:YES];
        return nil;
    }
    return indexPath;
}

- (void)viewDidAppear:(BOOL)animated {
    [self UpdateCurrencies];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    usdValue = 0;
    currencyUpdated = false;
    
    curFormatter = [[NSNumberFormatter alloc] init];
    [curFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.lblUSD.hidden = YES;
    self.btnReset.hidden = YES;
    
    //background
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //button styles
    self.btnReset.layer.cornerRadius = 10;
    self.btnReset.clipsToBounds = YES;
    self.btnReset.backgroundColor = [Utilities colorFromHexString:themeColor];
    
    //load supported currencies
    supportedCurrencies = [Utilities initCurrencies];
    
    [self UpdateCurrencies];
    
    //Load LocalMemo
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.LocalMemo.curr) {
        selCurrency = appDelegate.LocalMemo.curr;
        self.lblCurrencyName.text = selCurrency.name;
        self.lblUSD.hidden = [selCurrency.name isEqualToString:@"US Dollar"];
    } else {
        selCurrency = [supportedCurrencies objectAtIndex:0];
    }
    if (appDelegate.LocalMemo.currAmount) {
        usdValue = appDelegate.LocalMemo.currAmount;
        self.inputField.text = [NSString stringWithFormat:@"%.02f", usdValue];
    } else {
        usdValue = 100;
        self.inputField.text = @"100";
    }
    self.btnReset.hidden = ([self.inputField.text floatValue] == 100);
    [self showCurrencyRate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (self.inputField.editing && ![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)inputValueChanged:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Currency Input Amount" withValue:nil];
    float currAmount = [self.inputField.text floatValue];
    self.btnReset.hidden = (currAmount == 100);
    [self doCalCurrencies];
    
    //Update LocalMemo
    appDelegate.LocalMemo.currAmount = currAmount;
}

- (IBAction)btnResetTapped:(id)sender {
    [Utilities trackEvent:@"Reset button pressed" inCategory:@"Button" withLabel:@"Currency Reset Button" withValue:nil];
    self.inputField.text = @"100";
    self.btnReset.hidden = YES;
    [self doCalCurrencies];
    
    //Update LocalMemo
    appDelegate.LocalMemo.currAmount = 100;
}

- (IBAction)inputEnter:(id)sender {
    [sender selectAll:nil];
}

-(void)showCurrencyRate {
    usdValue = [self.inputField.text floatValue];
    if (![selCurrency.name isEqualToString:@"US Dollar"]) {
        usdValue = usdValue / selCurrency.rate;
        self.lblUSD.text = [NSString stringWithFormat:@"Rate: 1 USD = %.2f %@", selCurrency.rate, selCurrency.code];
    }
}

- (void)doCalCurrencies {
    [self showCurrencyRate];
    
    NSIndexPath *selIndex = self.lstCurrency.indexPathForSelectedRow;
    [self.lstCurrency reloadData];
    if (selIndex != nil) {
        [self.lstCurrency selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    [Utilities updateDBCurrencies:currencies supportedCurrencies:supportedCurrencies];
    currencyUpdated = true;
    [self LoadLocalCurrencies];
}

-(void)UpdateCurrencies {
    if (currencyUpdated)
        return;
    
    if ([Utilities InternetConnected]) {
        self.req = [[CRCurrencyRequest alloc] init];
        self.req.delegate = self;
        [self.req start];
    } else {
        currencyUpdated = false;
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"No Internet"
                                      message:@"No Internet, cannot get any currency rates. Will load currencies from local."
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
    supportedCurrencies = [Utilities loadCurrencyRatesFromLocal:supportedCurrencies];
    [self.lstCurrency reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utilities trackScreen:@"Currency Tool"];
}

@end
