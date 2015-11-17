//
//  ConvertiewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-10-31.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "ConvertViewController.h"
#import "utilities.h"
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

@end

@implementation ConvertViewController

NSArray *allUnits;
NSMutableArray *units;
unit *unit1, *unit2;
int activeUnit;
float convertRate;
NSSortDescriptor *sort;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)segCategoryValueChanged:(id)sender {
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

- (IBAction)inputUnit1Changed:(id)sender {
    activeUnit = 1;
    [self doCalculate];
}

- (IBAction)inputUnit2Changed:(id)sender {
    activeUnit = 2;
    [self doCalculate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    allUnits = [Utilities initUnits];
    self.segCategory.selectedSegmentIndex = 0;
    self.pickerUnits.hidden = YES;
    sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
    [self.segCategory sendActionsForControlEvents:UIControlEventValueChanged];
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
    if (activeUnit == 1) {
        float amount1 = [self.inputUnit1.text floatValue];
        self.inputUnit2.text = [NSString stringWithFormat:@"%g", amount1 * convertRate];
    } else if (activeUnit == 2) {
        float amount2 = [self.inputUnit2.text floatValue];
        self.inputUnit1.text = [NSString stringWithFormat:@"%g", amount2 / convertRate];
    }
}

- (IBAction)btnUnit1Tapped:(id)sender {
    activeUnit = 1;
    self.pickerUnits.hidden = NO;
}

- (IBAction)btnUnit2Tapped:(id)sender {
    activeUnit = 2;
    self.pickerUnits.hidden = NO;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    unit *unit = [units objectAtIndex: row];
    return unit.name;
}

@end
