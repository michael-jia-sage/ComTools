//
//  utilities.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CurrencyRequest/CRCurrencyResults.h"
#import "DBManager.h"

@interface Utilities : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSMutableArray *)initUnits;
+ (NSMutableArray *)initCurrencies;
+ (BOOL)InternetConnected;
+ (void)trackScreen:(NSString *)screenName;
+ (void)trackEvent:(NSString *)eventName inCategory:(NSString *)catName withLabel:(NSString *)label withValue:(NSNumber *)value ;
+ (void)updateDBCurrencies:(CRCurrencyResults *)currencies supportedCurrencies:(NSMutableArray *)supportedCurrencies;
+ (NSMutableArray *)loadCurrencyRatesFromLocal:(NSMutableArray *)supportedCurrencies;
@end
