//
//  utilities.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reachable.h"
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

+ (NSArray *)initUnits {
    NSArray *units = [[NSArray alloc] initWithObjects:
                      //
                      [[unit alloc] initWithName:@"Meter" category: Length abbr:@"m" sortOrder:1 rate:1 selectedAs:1]
                    ,[[unit alloc] initWithName:@"Kilometer" category: Length abbr:@"km" sortOrder:2 rate:1000 selectedAs:2]
                    ,[[unit alloc] initWithName:@"Mile" category: Length abbr:@"mile" sortOrder:3 rate:1609.34 selectedAs:0]
                    ,[[unit alloc] initWithName:@"Yard" category: Length abbr:@"yard" sortOrder:4 rate:0.9144 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Foot" category: Length abbr:@"foot" sortOrder:5 rate:0.3048 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Inch" category: Length abbr:@"inch" sortOrder:6 rate:0.0254 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Centimetre" category: Length abbr:@"cm" sortOrder:7 rate:0.01 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Millimetre" category: Length abbr:@"mm" sortOrder:8 rate:0.001 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Nanometre" category: Length abbr:@"nm" sortOrder:9 rate:0.000000001 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Gram" category: Weight abbr:@"g" sortOrder:1 rate:1 selectedAs:1]
                      ,[[unit alloc] initWithName:@"Kilogram" category: Weight abbr:@"kg" sortOrder:2 rate:1000 selectedAs:2]
                      ,[[unit alloc] initWithName:@"Pound" category: Weight abbr:@"lb" sortOrder:3 rate:454 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Ounce" category: Weight abbr:@"oz" sortOrder:4 rate:28.3495 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Stone" category: Weight abbr:@"stone" sortOrder:5 rate:6350.288 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Tonne" category: Weight abbr:@"ton" sortOrder:6 rate:1000000 selectedAs:0]
                      ,[[unit alloc] initWithName:@"US ton" category: Weight abbr:@"ton" sortOrder:7 rate:907185 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial ton" category: Weight abbr:@"ton" sortOrder:8 rate:1016050 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Milligram" category: Weight abbr:@"mg" sortOrder:9 rate:0.001 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Microgram" category: Weight abbr:@"ug" sortOrder:10 rate:0.000001 selectedAs:0]
                    ,[[unit alloc] initWithName:@"Square meter" category:Area abbr:@"m\u00B2" sortOrder:1 rate:1 selectedAs:1]
                    ,[[unit alloc] initWithName:@"Square feet" category: Area abbr:@"ft\u00B2" sortOrder:2 rate:0.092903 selectedAs:2]
                      ,[[unit alloc] initWithName:@"Acre" category: Area abbr:@"acre" sortOrder:3 rate:4046.86 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Hectare" category: Area abbr:@"ha" sortOrder:4 rate:10000 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Square Kilometer" category: Area abbr:@"km\u00B2" sortOrder:5 rate:1000000 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Square Inch" category: Area abbr:@"in\u00B2" sortOrder:6 rate:0.00064516 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Square Yard" category: Area abbr:@"yd\u00B2" sortOrder:7 rate:0.836127 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Square Mile" category: Area abbr:@"mile\u00B2" sortOrder:8 rate:2589990 selectedAs:0]
                    ,[[unit alloc] initWithName:@"Litre" category: Volumn abbr:@"l" sortOrder:1 rate:1 selectedAs:1]
                    ,[[unit alloc] initWithName:@"US Gallon" category: Volumn abbr:@"gal" sortOrder:2 rate:3.78541178 selectedAs:2]
                      ,[[unit alloc] initWithName:@"Cubic Meter" category: Volumn abbr:@"m\u00B3" sortOrder:3 rate:1000 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Cubic Foot" category: Volumn abbr:@"ft\u00B3" sortOrder:4 rate:28.3168 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Cubic Inch" category: Volumn abbr:@"in\u00B3" sortOrder:5 rate:0.0163871 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Millilitre" category: Volumn abbr:@"ml" sortOrder:6 rate:0.001 selectedAs:0]
                      ,[[unit alloc] initWithName:@"US Quart" category: Volumn abbr:@"qt" sortOrder:7 rate:0.946353 selectedAs:0]
                      ,[[unit alloc] initWithName:@"US Pint" category: Volumn abbr:@"pt" sortOrder:8 rate:0.473176 selectedAs:0]
                      ,[[unit alloc] initWithName:@"US Cup" category: Volumn abbr:@"cup" sortOrder:9 rate:0.24 selectedAs:0]
                      ,[[unit alloc] initWithName:@"US Fluid Ounce" category: Volumn abbr:@"fl oz" sortOrder:10 rate:0.0295735 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial Gallon" category: Volumn abbr:@"gal" sortOrder:11 rate:4.54609 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial Quart" category: Volumn abbr:@"qt" sortOrder:12 rate:1.13652 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial Pint" category: Volumn abbr:@"pt" sortOrder:13 rate:0.568261 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial Cup" category: Volumn abbr:@"cup" sortOrder:14 rate:0.284131 selectedAs:0]
                      ,[[unit alloc] initWithName:@"Imperial Fluid Ounce" category: Volumn abbr:@"fl oz" sortOrder:15 rate:0.0284131 selectedAs:0]
                             ,[[unit alloc] initWithName:@"Celsius" category: Other abbr:@"\u00B0C" sortOrder:1 rate:0 selectedAs:1]
                             ,[[unit alloc] initWithName:@"Fahrenheit" category: Other abbr:@"\u00B0F" sortOrder:2 rate:0 selectedAs:2]
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

+ (BOOL)InternetConnected
{
    reachable *reachability = [reachable reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end