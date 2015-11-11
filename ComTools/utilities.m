//
//  utilities.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "utilities.h"
#import "currency.h"
#import "unit.h"

@implementation Utilities

// Assumes input like "00FF00" (RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSMutableArray *)initUnits {
    NSMutableArray *units = [[NSMutableArray alloc] initWithObjects:
                             [[unit alloc] initWithName:@"Meter" category: Length abbr:@"m" sortOrder:1 rate:1]
                             ,[[unit alloc] initWithName:@"Kilometer" category: Length abbr:@"km" sortOrder:2 rate:1000]
                             ,[[unit alloc] initWithName:@"Mile" category: Length abbr:@"mile" sortOrder:3 rate:1600]
                             ,[[unit alloc] initWithName:@"Gram" category: Weight abbr:@"g" sortOrder:1 rate:1]
                             ,[[unit alloc] initWithName:@"Kilogram" category: Weight abbr:@"kg" sortOrder:2 rate:1000]
                             ,[[unit alloc] initWithName:@"Pound" category: Weight abbr:@"lb" sortOrder:3 rate:454]
                             ,[[unit alloc] initWithName:@"Square meter" category:Area abbr:@"m^2" sortOrder:1 rate:1]
                             ,[[unit alloc] initWithName:@"Square feet" category: Area abbr:@"sqft" sortOrder:2 rate:0.092903]
                             ,[[unit alloc] initWithName:@"Litre" category: Volumn abbr:@"l" sortOrder:1 rate:1]
                             ,[[unit alloc] initWithName:@"Gallon" category: Volumn abbr:@"gallon" sortOrder:2 rate:3.78541178]
                             ,[[unit alloc] initWithName:@"Celsius" category: Other abbr:@"C" sortOrder:1 rate:0]
                             ,[[unit alloc] initWithName:@"Fahrenheit" category: Other abbr:@"F" sortOrder:2 rate:0]
                             , nil];
    return units;
}

+ (NSMutableArray *)initCurrencies {
    NSMutableArray *supportedCurrencies = [[NSMutableArray alloc] initWithObjects:
                           [[currency alloc] initWithName:@"US Dollar" code:@"USD" sortOrder:1]
                           ,[[currency alloc] initWithName:@"Canada Dollar" code:@"CAD" sortOrder:2]
                           ,[[currency alloc] initWithName:@"China Yuan RMB" code:@"CNY" sortOrder:3]
                           ,[[currency alloc] initWithName:@"Euro" code:@"EUR" sortOrder:4]
                           ,[[currency alloc] initWithName:@"United Kingdom Pound" code:@"GBP" sortOrder:5]
                           ,[[currency alloc] initWithName:@"Japan Yen" code:@"JPY" sortOrder:6]
                           ,[[currency alloc] initWithName:@"Hong Kong Dollar" code:@"HKD" sortOrder:7]
                           //,[[currency alloc] initWithName:@"Taiwan New Dollar" code:@"TWD" sortOrder:8]
                           ,[[currency alloc] initWithName:@"Australia Dollar" code:@"AUD" sortOrder:9]
                           ,[[currency alloc] initWithName:@"Korea (South) Won" code:@"KRW" sortOrder:10]
                           ,[[currency alloc] initWithName:@"Russia Ruble" code:@"RUB" sortOrder:11]
                           ,[[currency alloc] initWithName:@"Thailand Baht" code:@"THB" sortOrder:12]
                           ,[[currency alloc] initWithName:@"Switzerland Franc" code:@"CHF" sortOrder:13]
                           ,[[currency alloc] initWithName:@"Brazil Real" code:@"BRL" sortOrder:14]
                           , nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
    [supportedCurrencies sortUsingDescriptors:@[sort]];
    
    return supportedCurrencies;
}

@end