//
//  XMLParser.h
//  VTFeeds
//
//  Created by Vincent Ngo on 3/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Article;

@interface XMLParser : NSObject <NSXMLParserDelegate>

//An article object that stores fields such as title, description, link, image url, etc
@property (nonatomic, strong)Article *aArticle;

//listOfArticle will store a list of article objects.
@property (nonatomic, strong)NSMutableArray *listOfArticle;

//The value in between the html tags <title> .... </title>
@property (nonatomic, strong) NSMutableString *currentElementValue;
@property (nonatomic, strong) NSString * currentElement;


//Description
@property (nonatomic, strong) NSMutableString *tagString;


//Fields to store in article
@property (nonatomic, strong)NSMutableString *title;
@property (nonatomic, strong)NSMutableString *Link;
@property (nonatomic, strong)NSMutableString *theDate;
@property (nonatomic, strong)NSMutableString *description;


//instance of NSXMLParser to parse XML files
@property NSXMLParser *parser;


-(id) loadXMLByURL:(NSString *)urlString;

//counter to give a unique number to every article we parse. e.g. key1, key2, key3, keyi, .....
@property int counter ;

@end


