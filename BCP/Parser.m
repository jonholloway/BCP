//
//  Parser.m
//  Reader
//
//  Created by Jon Holloway on 16/05/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "Parser.h"

@implementation Parser

-(id) initParser{
    if (self ==[super init]){
        
        app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return self;
        }

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"filelist"]) {
        
        Store * myStore = [Store sharedStore];
        listArray = [myStore fileNames];
    }
    else if ([elementName isEqualToString:@"file"]){
        return;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
 currentElementValue = [string  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"filelist"]){
        return;
    }
    if ([elementName isEqualToString:@"file"]) {
        
        [listArray addObject:currentElementValue];
        currentElementValue = nil;
    }
}
@end


