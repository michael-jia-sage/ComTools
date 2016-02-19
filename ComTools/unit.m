//
//  unit.m
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-10.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import "unit.h"

@implementation unit

- (id)initWithName:(NSString *)aName category:(UnitCategory)aCategory abbr:(NSString *)aAbbr sortOrder:(int)aSortOrder rate:(double)aRate selectedAs:(int)aSelectedAs {
    unit *u = [[unit alloc] init];
    u.name = aName;
    u.category = aCategory;
    u.abbr = aAbbr;
    u.sortOrder = aSortOrder;
    u.rate  = aRate;
    u.selectedAs = aSelectedAs;
    return u;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"UNIT_NAME"];
    [aCoder encodeInt:self.category forKey:@"UNIT_CATEGORY"];
    [aCoder encodeObject:self.abbr forKey:@"UNIT_ABBR"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.sortOrder] forKey:@"UNIT_SORTORDER"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.rate] forKey:@"UNIT_RATE"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.selectedAs] forKey:@"UNIT_SELECTEDAS"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"UNIT_NAME"];
        self.category = [aDecoder decodeIntegerForKey:@"UNIT_CATEGORY"];
        self.abbr = [aDecoder decodeObjectForKey:@"UNIT_ABBR"];
        self.sortOrder = [[aDecoder decodeObjectForKey:@"UNIT_SORTORDER"] intValue];
        self.rate = [[aDecoder decodeObjectForKey:@"UNIT_RATE"] floatValue];
        self.selectedAs = [[aDecoder decodeObjectForKey:@"UNIT_SELECTEDAS"] intValue];
    }
    return self;
}

@end
