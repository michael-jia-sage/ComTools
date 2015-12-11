//
//  ConvertiewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-10-31.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "ConvertViewController.h"
#import "utilities.h"
#import "constants.h"
#import "unit.h"

@interface ConvertViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnUnit1;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit1;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit1;
@property (weak, nonatomic) IBOutlet UIButton *btnUnit2;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit2;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit2;
@property (weak, nonatomic) IBOutlet UILabel *lblFormat;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerUnits;
@property (weak, nonatomic) IBOutlet UIButton *btnResetUnit1;
@property (weak, nonatomic) IBOutlet UIButton *btnResetUnit2;

@end

@implementation ConvertViewController

NSArray *allUnits;
NSMutableArray *units;
unit *unit1, *unit2;
int activeUnit;
bool reverseCal;
float convertRate;
NSSortDescriptor *sort;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (!self.pickerUnits.isHidden && ![[touch view] isKindOfClass:[UIPickerView class]]) {
        self.pickerUnits.hidden = YES;
        return;
    }

    if ((self.inputUnit1.editing || self.inputUnit2.editing) && ![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)segCategoryValueChanged:(id)sender {
    [Utilities trackEvent:@"Segment value changed" inCategory:@"Segment" withLabel:@"Convert Segment" withValue:[NSNumber numberWithInteger: self.segCategory.selectedSegmentIndex]];

    UnitCategory category = (UnitCategory)self.segCategory.selectedSegmentIndex;

    NSPredicate *p = [NSPredicate predicateWithFormat:@"category = %d", (int)category];
    units = [[NSMutableArray alloc] initWithArray: [allUnits filteredArrayUsingPredicate:p]];

    for (unit *u in units) {
        if (u.selectedAs == 1)
            unit1 = u;
        else if (u.selectedAs == 2)
            unit2 = u;
    }
    [units removeObject: unit1];
    [units removeObject: unit2];
    [units sortUsingDescriptors:@[sort]];
    
    [self.pickerUnits reloadAllComponents];
    [self doRefresh];
    [self doCalculate];
}

- (IBAction)editBegin:(id)sender {
    self.pickerUnits.hidden = YES;
}

- (IBAction)inputUnit1Changed:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Convert Input Unit 1" withValue:nil];
    [self doCalculate];
}

- (IBAction)inputUnit2Changed:(id)sender {
    [Utilities trackEvent:@"Input value changed" inCategory:@"Input Entry" withLabel:@"Convert Input Unit 2" withValue:nil];
    reverseCal = true;
    [self doCalculate];
    reverseCal = false;
}

- (IBAction)inputEnter:(id)sender {
    [sender selectAll:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //background
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //button styles
    self.btnResetUnit1.layer.cornerRadius = self.btnResetUnit2.layer.cornerRadius = 10;
    self.btnResetUnit1.clipsToBounds = self.btnResetUnit2.clipsToBounds = YES;
    self.btnResetUnit1.backgroundColor = self.btnResetUnit2.backgroundColor = [Utilities colorFromHexString:themeColor];
    
    //picker view style
    [self.view bringSubviewToFront:self.pickerUnits];
    allUnits = [Utilities initUnits];
    self.segCategory.selectedSegmentIndex = 0;
    self.pickerUnits.hidden = YES;
    reverseCal = false;
    sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
    self.inputUnit1.text = @"1";
    [self.segCategory sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)changeUnit:(id)sender
{
    [self.pickerUnits resignFirstResponder];
}

- (void)doRefresh {
    [self.btnUnit1 setTitle:unit1.name forState:UIControlStateNormal];
    self.lblUnit1.text = unit1.abbr;
    
    [self.btnUnit2 setTitle:unit2.name forState:UIControlStateNormal];
    self.lblUnit2.text = unit2.abbr;
    
    convertRate = unit1.rate / unit2.rate;
    
    self.lblFormat.text = [NSString stringWithFormat:@"1 %@ = %g %@", unit1.abbr, convertRate, unit2.abbr];
}

- (void)doCalculate {
    if (!reverseCal) {
        float amount1 = [self.inputUnit1.text floatValue];
        self.inputUnit2.text = [NSString stringWithFormat:@"%g", amount1 * convertRate];
    } else {
        float amount2 = [self.inputUnit2.text floatValue];
        self.inputUnit1.text = [NSString stringWithFormat:@"%g", amount2 / convertRate];
    }
}

- (IBAction)btnUnit1Tapped:(id)sender {
    activeUnit = 1;
    [self.view endEditing:YES];
    self.pickerUnits.hidden = NO;
}

- (IBAction)btnUnit2Tapped:(id)sender {
    activeUnit = 2;
    [self.view endEditing:YES];
    self.pickerUnits.hidden = NO;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [Utilities trackEvent:@"PickerView selected" inCategory:@"PickerView" withLabel:@"Convert Unit Picker" withValue:nil];

    self.pickerUnits.hidden = YES;
    unit *selUnit = [units objectAtIndex: row];
    unit *tmpUnit;
    if (activeUnit == 1) {
        tmpUnit = [[unit alloc] initWithName:unit1.name category:unit1.category abbr:unit1.abbr sortOrder:unit1.sortOrder rate:unit1.rate selectedAs:0];
        unit1 = [[unit alloc] initWithName:selUnit.name category:selUnit.category abbr:selUnit.abbr sortOrder:selUnit.sortOrder rate:selUnit.rate selectedAs:1];
    } else {
        tmpUnit = [[unit alloc] initWithName:unit2.name category:unit2.category abbr:unit2.abbr sortOrder:unit2.sortOrder rate:unit2.rate selectedAs:0];
        unit2 = [[unit alloc] initWithName:selUnit.name category:selUnit.category abbr:selUnit.abbr sortOrder:selUnit.sortOrder rate:selUnit.rate selectedAs:2];
    }
    selUnit.name = tmpUnit.name;
    selUnit.category = tmpUnit.category;
    selUnit.abbr = tmpUnit.abbr;
    selUnit.sortOrder = tmpUnit.sortOrder;
    selUnit.rate = tmpUnit.rate;
    selUnit.selectedAs = tmpUnit.selectedAs;
    
    [units sortUsingDescriptors:@[sort]];
    [self.pickerUnits reloadAllComponents];
    [self doRefresh];
    [self doCalculate];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [units count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    unit *unit = [units objectAtIndex: row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:unit.name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

- (IBAction)btnSwitchTapped:(id)sender {
    [Utilities trackEvent:@"Switch button pressed" inCategory:@"Button" withLabel:@"Convert Switch" withValue:nil];
    unit *tmpUnit = unit1;
    unit1 = unit2;
    unit2 = tmpUnit;
    [self doRefresh];
    NSString *tmpStr = self.inputUnit1.text;
    self.inputUnit1.text = self.inputUnit2.text;
    self.inputUnit2.text = tmpStr;
}

- (IBAction)btnResetUnit1Tapped:(id)sender {
    [Utilities trackEvent:@"Reset button pressed" inCategory:@"Button" withLabel:@"Convert Reset Unit 1" withValue:nil];
    
    self.inputUnit1.text = @"1";
    [self doCalculate];
}

- (IBAction)btnResetUnit2Tapped:(id)sender {
    [Utilities trackEvent:@"Reset button pressed" inCategory:@"Button" withLabel:@"Convert Reset Unit 2" withValue:nil];
    self.inputUnit2.text = @"1";
    reverseCal = true;
    [self doCalculate];
    reverseCal = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utilities trackScreen:@"Convert Tool"];
}
@end
