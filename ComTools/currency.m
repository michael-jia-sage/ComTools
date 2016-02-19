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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"CURRENCY_NAME"];
    [aCoder encodeObject:self.code forKey:@"CURRENCY_CODE"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.sortOrder] forKey:@"CURRENCY_SORTORDER"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.rate] forKey:@"CURRENCY_RATE"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"CURRENCY_NAME"];
        self.code = [aDecoder decodeObjectForKey:@"CURRENCY_CODE"];
        self.sortOrder = [[aDecoder decodeObjectForKey:@"CURRENCY_SORTORDER"] intValue];
        self.rate = [[aDecoder decodeObjectForKey:@"CURRENCY_RATE"] floatValue];
    }
    return self;
}

@end
