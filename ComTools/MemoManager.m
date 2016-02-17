//
//  MemoManager.m
//  ComTools
//
//  Created by Zonggao Jia on 2016-02-13.
//  Copyright © 2016 Zonggao Jia. All rights reserved.
//

#import "MemoManager.h"
#import "localmemo.h"

@implementation MemoManager

+(localmemo *)loadMemoFromFile:(NSString *)xmlFilename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Set the documents directory path to the documentsDirectory property.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:xmlFilename];
    if ([fileManager fileExistsAtPath:fullPath]){
        localmemo *lm = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        return lm;
    } else {
        return nil;
    }
}

+(void)writeMemoToFile:(NSString *)xmlFilename memo:(localmemo *)lm {
    // Set the documents directory path to the documentsDirectory property.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:xmlFilename];
    [NSKeyedArchiver archiveRootObject:lm toFile:fullPath];
}

@end
