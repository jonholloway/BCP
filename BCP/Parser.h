//
//  Parser.h
//  Reader
//
//  Created by Jon Holloway on 16/05/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "AppDelegate.h"


@interface Parser : NSObject <NSXMLParserDelegate>{

    
    AppDelegate *app;
    NSString *currentElementValue;
    NSMutableArray *listArray;
    
}

-(id)initParser;


@end
