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
static localmemo *localMemo;

+(localmemo *)LocalMemo {
    if (localMemo == nil) {
        localMemo = [[localmemo alloc] init];
        localMemo.unit1Value = 1;
        localMemo.unit2Value = 100;
    }
    return localMemo;
}

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

+(void)writeMemoToFile:(NSString *)xmlFilename memo:(localmemo *)lm{
    NSString *error = nil;
    NSData *mySerializedObject = [NSKeyedArchiver archivedDataWithRootObject:lm];
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:mySerializedObject
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                       errorDescription:&error];
    if( xmlData ) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:xmlFilename];
        [xmlData writeToFile:fullPath atomically:YES];
    } else {
        NSLog(@"Error when write to xml file -- %@", error);
    }
}

@end
