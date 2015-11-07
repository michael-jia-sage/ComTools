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
@property (nonatomic) CRCurrencyResults *res;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UILabel *currencyA;
@property (weak, nonatomic) IBOutlet UILabel *currencyB;
@property (weak, nonatomic) IBOutlet UILabel *currencyC;
@property (weak, nonatomic) IBOutlet UITableView *lstCurrency;

@end

@implementation CurrencyViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[CRCurrencyResults supportedCurrencies] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [[[CRCurrencyResults supportedCurrencies] allObjects] objectAtIndex:indexPath.row];
    
    UITextField *txtAmount = [[UITextField alloc] initWithFrame:CGRectMake(100, 13, 200, 30)];
    txtAmount.placeholder = @"Amount";
    [txtAmount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtAmount setKeyboardType:UIKeyboardTypeDecimalPad];
    [txtAmount addTarget:self action:@selector(doConvert) forControlEvents:UIControlEventEditingDidEnd];
    
    [cell addSubview:txtAmount];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Currencies";
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.req = [[CRCurrencyRequest alloc] init];
    
    self.req.delegate = self;
    [self.req start];
}

- (void)doConvert {
    self.convertButton.enabled = NO;
    self.req = [[CRCurrencyRequest alloc] init];
    
    self.req.delegate = self;
    [self.req start];
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    
    double inputValue = [self.inputField.text floatValue];
    double euroValue = inputValue * currencies.EUR;
    double yenValue = inputValue * currencies.JPY;
    double gbpValue = inputValue * currencies.GBP;
    
    
    self.currencyA.text = [NSString stringWithFormat:@"%.2f", euroValue];
    self.currencyB.text = [NSString stringWithFormat:@"%.2f", yenValue];
    self.currencyC.text = [NSString stringWithFormat:@"%.2f", gbpValue];
    
    self.convertButton.enabled = YES;
}

@end
