//
//  Store.m
//  test1
//
//  Created by Jon Holloway on 14/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "Store.h"
#import "ReaderViewController.h"


@implementation Store
@synthesize passedText;
@synthesize passedData;
@synthesize downloadedFile;

static Store *sharedStore = nil;

+ (Store *) sharedStore {
    @synchronized (self) {
        if (sharedStore == nil) {
            sharedStore = [[self alloc]init];
            sharedStore.passedData = [[NSMutableArray alloc]init];
            sharedStore.fileNames = [[NSMutableArray alloc]init];
        }
    }
    return sharedStore;
}

+ (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(void)moveFiles:(NSString *)fileName {
    
    NSString *plistFileName = [fileName stringByAppendingPathExtension:@"plist"];
    NSString *pdfFileName =[fileName stringByAppendingPathExtension:@"pdf"];
    
    NSURL *plistURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:plistFileName];
    NSURL *pdfURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pdfFileName];
    
    if( ![[NSFileManager defaultManager]
          fileExistsAtPath:[plistURL path]] )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        copyItemAtPath:plistPath toPath:[plistURL path] error:&anyError];
    }
     
    if( ![[NSFileManager defaultManager]
          fileExistsAtPath:[pdfURL path]] )
    {
        NSString *pdfPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf" inDirectory:nil];
        
        //check if a later version exists on the web site
        //if it does then download and use that version
        //if not then carry on as normal and move it from the bundle
        
        if ([self checkFileDates:pdfPath :fileName])
        {
            // No updated file - carry on
            
            NSError *anyError = nil;
            BOOL success = [[NSFileManager defaultManager]
                        copyItemAtPath:pdfPath toPath:[pdfURL path] error:&anyError];
        }
        else
        {
            //download updated file into documents directory
            [self downloadFile:fileName :pdfURL];
        }
    }
    else
    {
    //File already in documents directory
    //is it later than Web File. If not then download
    //otherwise use as is
    }
}

+(void)removeFiles:(NSString *)fileName {
    
    NSString *plistFileName = [fileName stringByAppendingPathExtension:@"plist"];
    NSString *pdfFileName =[fileName stringByAppendingPathExtension:@"pdf"];
    
    NSURL *plistURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:plistFileName];
    NSURL *pdfURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pdfFileName];
    
    if( [[NSFileManager defaultManager]
          fileExistsAtPath:[plistURL path]] )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        removeItemAtURL:plistURL error:&anyError];
    }
    Store * myStore = [Store sharedStore];
    if (myStore.downloadedFile.length == 0){
    
    if( [[NSFileManager defaultManager]
          fileExistsAtPath:[pdfURL path]] )
    {
        NSString *pdfPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        removeItemAtURL:pdfURL error:&anyError];
    }
    }
}

+(BOOL) checkFileDates:(NSString *)pathToFile :(NSString *)nameForFile {
    
    Store * myStore = [Store sharedStore];
    NSArray *fileList = [myStore fileNames];
    NSString *stringtosearch = [nameForFile stringByAppendingString:@".pdf,"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",stringtosearch];
    NSArray *results = [fileList filteredArrayUsingPredicate:predicate];
    BOOL *answer = YES;
    
    if (results.count < 1) {
        //File Not found in update list - cntinue
    }
    else
    {
        NSString  *fileFound = [results objectAtIndex:0];
        NSArray *thisFile = [fileFound componentsSeparatedByString:@","];
        NSString *dateString = [thisFile objectAtIndex:1];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *webDate = [formatter dateFromString:dateString];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:pathToFile error:nil];
        NSDate *bundleDate = [attributes fileCreationDate];
        if ([webDate compare:bundleDate] == NSOrderedAscending){
            answer = YES;
            //webDate is Before bundleDate - No update
        }
        else {
            answer = NO;
            // webDate After BundleDate - updated file available
        }
    }
    return answer;
}

+(void) downloadFile:(NSString *)nameForFile :(NSString *)pathToFile {

    NSString *fileName = [nameForFile stringByAppendingPathExtension:@"pdf"];
    NSString *webString = [@"http://www.health.sa.gov.au/appstore/pdfvault/" stringByAppendingString:fileName];
    NSURL *url = [NSURL URLWithString:webString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir  = [pathArray objectAtIndex:0];
    NSString *localFile = [documentsDir stringByAppendingPathComponent:fileName];
    
    [data writeToFile:localFile atomically:YES];
    Store * myStore = [Store sharedStore];
    myStore.downloadedFile = fileName;
}

@end
