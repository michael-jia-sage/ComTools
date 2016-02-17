//
//  MemoManager.h
//  ComTools
//
//  Created by Zonggao Jia on 2016-02-13.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "localmemo.h"

@interface MemoManager : NSObject

+(localmemo *)loadMemoFromFile:(NSString *)xmlFilename;
+(void)writeMemoToFile:(NSString *)xmlFilename memo:(localmemo *)lm;

@end
