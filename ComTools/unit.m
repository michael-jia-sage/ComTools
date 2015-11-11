//
//  unit.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-10.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "unit.h"

@implementation unit

- (id)initWithName:(NSString *)aName category:(UnitCategory)aCategory abbr:(NSString *)aAbbr sortOrder:(int)aSortOrder rate:(double)aRate {
    unit *u = [[unit alloc] init];
    u.name = aName;
    u.category = aCategory;
    u.abbr = aAbbr;
    u.sortOrder = aSortOrder;
    u.rate  = aRate;
    return u;
}

@end
