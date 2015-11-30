//
//  CompareViewController.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "CompareViewController.h"
#import "constants.h"
#import "utilities.h"

@interface CompareViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segOptions;
@property (weak, nonatomic) IBOutlet UILabel *lblFormat;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit1;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit2;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit1;
@property (weak, nonatomic) IBOutlet UITextField *inputUnit2;
@property (weak, nonatomic) IBOutlet UISlider *slideUnit1;
@property (weak, nonatomic) IBOutlet UISlider *slideUnit2;

@end

@implementation CompareViewController

int option = 0;
int inputIndex = 1;

-(void)viewDidLoad
{
    [super viewDidLoad];
    //background
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)segValueChanged:(id)sender {
    option = self.segOptions.selectedSegmentIndex;
    if (option == 1) {
        self.lblFormat.text = temperature_format;
        self.lblUnit1.text = @"\u00B0C";
        self.lblUnit2.text = @"\u00B0F";
        self.inputUnit1.text = @"0";
    } else {
        self.lblFormat.text = gas_price_format;
    }
}

- (IBAction)input1Changed:(id)sender {
    inputIndex = 1;
    [self doCompare];
}

- (IBAction)input2Changed:(id)sender {
    inputIndex = 2;
    [self doCompare];
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
            self.inputUnit2.text = [NSString stringWithFormat:@"%2f", input2];
        } else {
            //F to C
            float input2 = [self.inputUnit2.text floatValue];
            float input1 = (input2 - 32) * 5 / 9;
            self.inputUnit1.text = [NSString stringWithFormat:@"%2f", input1];
        }
    } else {
        
    }
        
}
@end
