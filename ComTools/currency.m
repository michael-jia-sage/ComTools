//
//  currency.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-09.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "currency.h"

@implementation currency

- (id)initWithName:(NSString *)aName code:(NSString *)aCode sortOrder:(int)aSortOrder {
    return [self initWithName:aName code:aCode sortOrder:aSortOrder rate: 0];
}

- (id)initWithName:(NSString *)aName code:(NSString *)aCode sortOrder:(int)aSortOrder rate:(double)aRate {
    currency *c = [[currency alloc] init];
    c.name = aName;
    c.code = aCode;
    c.sortOrder = aSortOrder;
    c.rate  = aRate;
    return c;
}

@end
