//
//  XMLParser.m
//  VTFeeds
//
//  Created by Vincent Ngo on 4/12/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "XMLParser.h"
#import "Article.h"

//Virginia Tech News Feed XML Format for 1 item.

// <item>
// <title>
// Jon Greene named associate director for strategic planning and development at institute
// </title>
// <link>
// http://www.vtnews.vt.edu/articles/2013/03/031513-ictas-greenepromotion.html
// </link>
// <description>
// <p>In this new position, Jon Greene will be responsible for strategic research development of multimillion-dollar, interdisciplinary proposals at the Institute for Critical Technology and Applied Science,</p>
// </description>
// <pubDate>Fri, 15 Mar 2013 00:00:00 -0400</pubDate>
// <guid isPermaLink="true">
// http://www.vtnews.vt.edu/articles/2013/03/031513-ictas-greenepromotion.html
// </guid>
// <enclosure url="http://www.vtnews.vt.edu/articles/2009/10/images/M_09783greene-jpg.jpg" length="27715" type="image/jpeg"/>
// <category>
// Institute for Critical Technology and Applied Science
// </category>
// <category>College of Engineering</category>
// <category>Research</category>
// <category>National Capital Region</category>
// </item>


//XML Parser - SAX Approach
// three protocols to implement : parser:didStartElement:namespaceURI:qualifiedName:attributes, parser:didEndElement:namespaceURI:qualifiedName
//parser:foundCharacters.


@implementation XMLParser

-(id) loadXMLByURL:(NSString *)urlString
{
    self.currentElementValue = [[NSMutableString alloc]init];
    [self.currentElementValue setString:@" "];
    
    self.description = [[NSMutableString alloc]init];
    self.theDate = [[NSMutableString alloc]init];
    self.title = [[NSMutableString alloc]init];
    self.Link = [[NSMutableString alloc]init];
    
    //Create a new instance of an NSMutableArray
	self.listOfArticle = [[NSMutableArray alloc] init];
    
    
    
    //Gather the contents from a url
	NSURL *url		= [NSURL URLWithString:urlString];
	NSData	*data   = [[NSData alloc] initWithContentsOfURL:url];
    //Create a new instance of NSXMLParser to parse the data we just gathered.
	self.parser		= [[NSXMLParser alloc] initWithData:data];
    
    //Set the NSXMLParser as the delegate.
	self.parser.delegate = self;
    
    // Start parsing the xml file
	[self.parser parse];
    
    self.counter = 0;
	return self;
}


// XMLParser.m

//Everytime it sees a new tag, its going to come here.
//We are only going to create a new article object only when we find the start of the tag <item>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    //Save a reference to the element/tag we are currently looking at.
    self.currentElement = elementName;
    
    //When finding the item tag, we will create an article object to start parsing the tags within the <item> tag. <item> ....... </item>
    if ([elementName isEqualToString:@"item"]) {
        
        //We have found an element/node called item in the XML file
        //Lets create a new article object to extract information and set the fields required by an article object.
        self.aArticle = [[Article alloc]init];
        
        //Given each item we set a unique key, so we can retrieve and cache images from NSMutableDictionary
        self.aArticle.key = [NSString stringWithFormat:@"art%d",self.counter];
        self.counter++;
        
    }
    
    //<enclosure url="http://www.vtnews.vt.edu/articles/2009/10/images/M_09783greene-jpg.jpg" length="27715" type="image/jpeg"/>
    //If a tag has parameters such as: url, length, type, we can access the value of them by the attributeDict
    if ([elementName isEqualToString:@"enclosure"]){
        self.aArticle.imageURL = [attributeDict valueForKey:@"url"];
    }
    
}

//XMLParser.m

//NSXMLParser will always call this method to check if we have reach a tag we want to parse in to our article object.

//When reaching the end of a tag, we will set the fields for an article.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    // NSLog(@"currentElementValue is %@", self.currentElementValue);
    
    //First check if an article object has been created, if not we haven't found an item in the XML file.
    if (self.aArticle != nil){
        
        //We found a title tag, and finished parsing all title characters.
        if ([elementName isEqualToString:@"title"]){
            
            //Set the article's title field.
            self.aArticle.title = self.title;
            
        }
        
        //We found a link tag, and finished parsing all link characters
        if ([elementName isEqualToString:@"link"]){
            
            //Set the articlle's link field.
            self.aArticle.aLink = self.Link;
            
        }
        
        
        //We found a date tag, and finished parsing all date characters
        if ([elementName isEqualToString:@"pubDate"]){
            
            //Set the article's date field.
            self.aArticle.datePublished = self.theDate;
            
        }
        
        //We found the description tag, and finished parsing all the description characters.
        if ([elementName isEqualToString:@"description"]){
            
            NSString *theDescription = [self removeTagDescription:self.description];
            self.aArticle.description = theDescription;
        }
        
        
        
        // We reached the end of the XML document </item>
        // We now need to add the parsed article to the array of parsed articles,
        //and then reset all the fields for the next article we may parse in the XML file.
        if ([elementName isEqualToString:@"item"]) {
            [self.listOfArticle addObject:self.aArticle];   // Add article object to the list.
            self.currentElementValue = nil;                 //Reset the current value, don't want any random data floating around.
            self.aArticle = nil;    //Reset the article to be recycled, reused.
            
            self.description = [[NSMutableString alloc]init];
            self.title = [[NSMutableString alloc]init];
            self.Link = [[NSMutableString alloc]init];
            self.theDate = [[NSMutableString alloc]init];
            
            return;
        }
        
    }
}


//This is called everytime we find a node xml tag - <tag>
//Its going to set the value found within the tag to currentElementValue extracted.
//This method will be called everytime it finds a character in the tag. In otherwards,
//it finds the value within the tags.
//E.g. <Description> ....... </Description>
//found Characters will find the following characters:
//      1. <
//      2. p
//      3. >
//      4. a long description
//      5. <
//      6. /
//      7. p
//      8. >
//So we must concatenate the strings.
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //Remove all new line characters, this is so web links don't include /n in the string
    //if it does, UIWebView cannot read it.
    NSString *stringWithoutNewLineCharacter = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Safety check to see if article is nil, if it is, we don't bother checking random tags which has article properties. We only check it when we know it is an article item in the
    //XML file.
    
    if (self.aArticle != nil){
        
        //If we are currently in the title tag, we want to concatenate the characters within the tag.
        if ([self.currentElement isEqualToString:@"title"])
        {
            [self.title appendString:stringWithoutNewLineCharacter];
        }
        
        //If we are currently in the link's tag, we want to concatenate the characters within the tag.
        if ([self.currentElement isEqualToString:@"link"]){
            if (![string isEqualToString:@"\n"]){
                [self.Link appendString:stringWithoutNewLineCharacter];
            }
            
        }
        //If we are currently in the pubDate tag, we want to concatenate the characters within the tag.
        if ([self.currentElement isEqualToString:@"pubDate"]){
            [self.theDate appendString:stringWithoutNewLineCharacter];
            
        }
        //If we are currently in the description tag, we want to concatenate the characters within the tag.
        if([self.currentElement isEqualToString:@"description"]){
            
            [self.description appendString:stringWithoutNewLineCharacter];
            
        }
    }
    
}

/**
 * Removes the <div> .... </div> tag in this string.
 */
-(NSMutableString *)removeDivTag:(NSMutableString *)someString{
    
    //Remove the starting <div> tag
    NSString *removeStartP = [someString stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    
    //Remove the ending </div> tag
    NSString *removeEndP = [removeStartP stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    
    //set the cleaned string back.
    [someString setString:removeEndP];
    
    return someString;
    
}

//Helper Methods to remove div tags. Virginia Tech News Feed XML file has some special cases we need to deal with. Such as <p> tags within div tags, and weird web tags such as:
//<div xmlns:o="urn:www.microsoft.com/office"xmlns:st1="urn:www.microsoft.com/smarttags"xmlns:st2="urn:www.microsoft.com/smarttags2"xmlns:w="urn:www.microsoft.com/word"xmlns:x="urn:www.microsoft.com/excel"> ........ </div>

/**
 * Remove the <p> .... </p> tag in this string.
 */
-(NSMutableString *)removePTag:(NSMutableString *)someString{
    
    //Remove the starting <p> tag
    NSString *removeStartP = [someString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    //Remove the ending </p> tag
    NSString *removeEndP = [removeStartP stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    //set the cleaned string back.
    [someString setString:removeEndP];
    
    return someString;
}

/**
 * <div xmlns:o="urn:www.microsoft.com/office"xmlns:st1="urn:www.microsoft.com/smarttags"xmlns:st2="urn:www.microsoft.com/smarttags2"xmlns:w="urn:www.microsoft.com/word"xmlns:x="urn:www.microsoft.com/excel"> ........ </div>
 *
 * Removing the funky microsoft tag.
 */

-(NSMutableString *)removeFunkyMicrosoftDivTag:(NSMutableString *)someString{
    
    //Finding the position of the first occurance of ">" in this case we want to add one to the location to remove everything before it include itself.
    int range = [someString rangeOfString:@">"].location + 1;
    [someString setString:[someString substringFromIndex:range]];
    
    //Next remove the ending div tag.
    [someString setString: [someString stringByReplacingOccurrencesOfString:@"</div>" withString:@""]];
    
    return someString;
}



//Removing description tag, html tags. <description> <div>  [   <p> ........ </p></div>    ]   </description>
- (NSMutableString *)removeTagDescription:(NSMutableString *)theDescription{
    
    //<Div> tag not found, and only <p> tag found.
    if ([theDescription rangeOfString:@"div"].location == NSNotFound && [theDescription rangeOfString:@"<p>"].location != NSNotFound){
        
        [theDescription setString:[self removePTag: theDescription]];
        
        //<div xmlns:o="urn:www.microsoft.com/office"xmlns:st1="urn:www.microsoft.com/smarttags"xmlns:st2="urn:www.microsoft.com/smarttags2"xmlns:w="urn:www.microsoft.com/word"xmlns:x="urn:www.microsoft.com/excel"> and <p> tags
    }else if ([theDescription rangeOfString:@"div"].location != NSNotFound && [theDescription rangeOfString:@"<p>"].location != NSNotFound && [theDescription rangeOfString:@"microsoft"].location != NSNotFound){
        
        [theDescription setString:[self removeFunkyMicrosoftDivTag:theDescription]];
        
        [theDescription setString:[self removePTag:theDescription]];
        
        //<div> tag found, and <p> tag not found, deal with removing only the div tag.
    }else if ([theDescription rangeOfString:@"div"].location != NSNotFound && [theDescription rangeOfString:@"<p>"].location == NSNotFound){
        
        [self.description setString:[self removeDivTag:self.description]];
        
        //Only <div> tag and <p> tag to remove.
    }else if ([theDescription rangeOfString:@"div"].location != NSNotFound && [theDescription rangeOfString:@"<p>"].location != NSNotFound && [theDescription rangeOfString:@"microsoft"].location == NSNotFound){
        
        [theDescription setString:[self removePTag:theDescription]];
        [theDescription setString:[self removeDivTag:theDescription]];
    }
    
    return theDescription;
    
    
}



@end
