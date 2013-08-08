//
//  Store.h
//  test1
//
//  Created by Jon Holloway on 14/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject <UIApplicationDelegate>
{
    NSString *passedText;
    NSMutableArray *passedData;
    NSString *downloadedFile;
      
}
@property (nonatomic, strong) NSString* passedText;
@property (nonatomic, strong) NSMutableArray* passedData;
@property (nonatomic,strong)  NSMutableArray* fileNames;
@property (nonatomic, strong) NSString *downloadedFile;


+(Store *) sharedStore;

+(void)moveFiles:(NSString *)fileName;
+(void)removeFiles:(NSString *)fileName;
+(BOOL)checkFileDates:(NSString *)pathToFile :(NSString *)nameForFile;
+(void)checkSQlDate:(NSString *)pathToFile :(NSString *)nameForFile;
+(void)downloadFile:(NSString *)nameForFile :(NSString *)pathToFile;
+ (NSURL *)applicationDocumentsDirectory;




@end
