//
//  unit.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-10.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Length,
    Weight,
    Area,
    Volumn,
    Time,
    Other
} UnitCategory;

@interface unit : NSObject

@property NSString *name;
@property UnitCategory category;
@property NSString *abbr;
@property int sortOrder;
@property double rate;

- (id)initWithName:(NSString *)aName category:(UnitCategory)aCategory abbr:(NSString *)aAbbr sortOrder:(int)aSortOrder rate:(double)aRate;

@end
