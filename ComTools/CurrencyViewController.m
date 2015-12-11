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

@interface CurrencyViewController () <CRCurrencyRequestDelegate>
@property (nonatomic) CRCurrencyRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *lstCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyName;
@property (weak, nonatomic) IBOutlet UILabel *lblUSD;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@end

@implementation CurrencyViewController
CRCurrencyResults *res;
double usdValue = 0;
NSMutableArray *supportedCurrencies;
currency *selCurrency;
NSNumberFormatter *curFormatter;
bool currencyUpdated = false;

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
    
    //[self doCalCurrencies];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.inputField.editing) {
        [self.inputField endEditing:YES];
        return nil;
    }
    return indexPath;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
//    [sectionView setBackgroundColor:[Utilities colorFromHexString:themeColor]];
//    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,22)];
////    tempLabel.shadowColor = [UIColor blackColor];
////    tempLabel.shadowOffset = CGSizeMake(0,2);
//    tempLabel.textColor = [UIColor whiteColor];
//    tempLabel.font = [UIFont boldSystemFontOfSize:16];
//    tempLabel.text=@"Tap to change";
//    
//    [sectionView addSubview:tempLabel];
//    return sectionView;
//}

- (void)viewDidAppear:(BOOL)animated {
    [self UpdateCurrencies];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    selCurrency = [supportedCurrencies objectAtIndex:0];
    
    self.inputField.text = @"100";
    usdValue = 100;
    
    [self UpdateCurrencies];
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
    self.btnReset.hidden = ([self.inputField.text floatValue] == 100);
    [self doCalCurrencies];
}

- (IBAction)btnResetTapped:(id)sender {
    [Utilities trackEvent:@"Reset button pressed" inCategory:@"Button" withLabel:@"Currency Reset Button" withValue:nil];
    self.inputField.text = @"100";
    self.btnReset.hidden = YES;
    [self doCalCurrencies];
}

- (IBAction)inputEnter:(id)sender {
    [sender selectAll:nil];
}

- (void)doCalCurrencies {
    usdValue = [self.inputField.text floatValue];
    if (![selCurrency.name isEqualToString:@"US Dollar"]) {
        usdValue = usdValue / selCurrency.rate;
        self.lblUSD.text = [NSString stringWithFormat:@"Rate: 1 USD = %.2f %@", selCurrency.rate, selCurrency.code];
    }
    
    NSIndexPath *selIndex = self.lstCurrency.indexPathForSelectedRow;
    [self.lstCurrency reloadData];
    if (selIndex != nil) {
        [self.lstCurrency selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    res = currencies;
    currencyUpdated = true;
    [self.lstCurrency reloadData];
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
                                      message:@"No Internet, cannot get any currency rates. Please check your network connection."
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
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utilities trackScreen:@"Currency Tool"];
}
@end
