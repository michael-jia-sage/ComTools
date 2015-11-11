//
//  currency.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-09.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface currency : NSObject
@property NSString *name;
@property NSString *code;
@property int sortOrder;
@property double rate;

- (id)initWithName:(NSString *)aName code:(NSString *)aCode sortOrder:(int)aSortOrder;
- (id)initWithName:(NSString *)aName code:(NSString *)aCode sortOrder:(int)aSortOrder rate:(double)rate;

@end
