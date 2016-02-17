//
//  localmemo.h
//  ComTools
//
//  Created by Zonggao Jia on 2016-02-13.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unit.h"
#import "currency.h"

@interface localmemo : NSObject

//converter
@property unit *unit1;
@property float unit1Value;
@property unit *unit2;

//calculator
@property float totalAmount;
@property float tipPercentage;
@property int groupSize;

//currency
@property currency *curr;
@property float currAmount;

//compare
@property int compareType;
@property float compareValue1;

@end
