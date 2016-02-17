//
//  localmemo.m
//  ComTools
//
//  Created by Zonggao Jia on 2016-02-13.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#import "localmemo.h"

@implementation localmemo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.unit1 forKey:@"UNIT1"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.unit1Value] forKey:@"UNIT1VALUE"];
    [aCoder encodeObject:self.unit2 forKey:@"UNIT2"];
    
    [aCoder encodeObject:[NSNumber numberWithFloat:self.totalAmount] forKey:@"TOTALAMOUNT"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.tipPercentage] forKey:@"TIPPERCENTAGE"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.groupSize] forKey:@"GROUPSIZE"];
    
    [aCoder encodeObject:self.curr forKey:@"CURRENCY"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.currAmount] forKey:@"CURRAMOUNT"];

    [aCoder encodeObject:[NSNumber numberWithInt:self.compareType] forKey:@"COMPARETYPE"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.compareValue1] forKey:@"COMPAREVALUE1"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.unit1 = [aDecoder decodeObjectForKey:@"UNIT1"];
        self.unit1Value = [[aDecoder decodeObjectForKey:@"UNIT1VALUE"] floatValue];
        self.unit2 = [aDecoder decodeObjectForKey:@"UNIT2"];

        self.totalAmount = [[aDecoder decodeObjectForKey:@"TOTALAMOUNT"] floatValue];
        self.tipPercentage = [[aDecoder decodeObjectForKey:@"TIPPERCENTAGE"] floatValue];
        self.groupSize = [[aDecoder decodeObjectForKey:@"GROUPSIZE"] intValue];
        
        self.curr = [aDecoder decodeObjectForKey:@"CURRENCY"];
        self.currAmount = [[aDecoder decodeObjectForKey:@"CURRAMOUNT"] floatValue];
        
        self.compareType = [[aDecoder decodeObjectForKey:@"COMPARETYPE"] floatValue];
        self.compareValue1 = [[aDecoder decodeObjectForKey:@"COMPAREVALUE1"] floatValue];
    }
    return self;
}

@end