//
//  utilities.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject {}

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSMutableArray *)initUnits;
+ (NSMutableArray *)initCurrencies;

@end
