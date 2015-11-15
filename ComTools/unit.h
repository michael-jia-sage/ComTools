//
//  unit.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-10.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Length = 0,
    Weight = 1,
    Area = 2,
    Volumn = 3,
    Time = 4,
    Other = 5
} UnitCategory;

@interface unit : NSObject

@property NSString *name;
@property UnitCategory category;
@property NSString *abbr;
@property int sortOrder;
@property double rate;
@property int selectedAs; //0 -- not selected; 1 -- as unit1; 2 -- as unit2

- (id)initWithName:(NSString *)aName category:(UnitCategory)aCategory abbr:(NSString *)aAbbr sortOrder:(int)aSortOrder rate:(double)aRate selectedAs:(int)aSelectedAs;

@end
