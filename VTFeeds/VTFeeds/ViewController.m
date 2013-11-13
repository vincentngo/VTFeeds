//
//  ViewController.m
//  VTFeeds
//
//  Created by Vincent Ngo on 4/10/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "ViewController.h"
#import "ArticleCell.h"
#import "Article.h"
#import "SocialWebViewController.h"

@interface ViewController ()

@end


/*
 Resources looked at:
 
 //Border around UIImageVIew
 http://intellidzine.blogspot.com/2011/06/uiimageview-with-border-and-shadow.html
 
 //Detail description about NS XML Parser, of course there are many other SAX/DOM Parsers we can use, but are third party.
 http://wiki.cs.unh.edu/wiki/index.php/Parsing_XML_data_with_NSXMLParser
 http://www.raywenderlich.com/553/how-to-chose-the-best-xml-parser-for-your-iphone-project
 http://mobile.tutsplus.com/tutorials/iphone/uiactionsheet_uiactionsheetdelegate/
 http://mobile.tutsplus.com/tutorials/iphone/mfmailcomposeviewcontroller/
 http://www.appcoda.com/ios-programming-101-send-email-iphone-app/
 
 http://stackoverflow.com/questions/6159844/making-a-load-more-button-in-uitableviewcell
 http://www.youtube.com/watch?v=hy88NtPvVro
 */


@implementation ViewController



- (void)viewDidLoad
{
    
    //Create an XML Parser object, with the Virginia Tech RSS Feed URL
    self.xmlParser = [[XMLParser alloc] loadXMLByURL:@"http://www.vtnews.vt.edu/articles/index-rss2.xml"];
    
    //Create a new NSMutableDictionary object so we can store images once they are downloaded.
    self.ImagesCacheDictionary = [[NSMutableDictionary alloc]init];
    
    //Get all the list of articles from the xmlParser that did all the parsing.
    self.listOfArticles = [self.xmlParser listOfArticle];
    
    [super viewDidLoad];
    
}


#pragma mark - Table View Data Source Methods

// Although the default is 1; it is still good to include this method for clarity
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Asks the data source to return the number of rows in a given section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfArticles count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (ArticleCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:@"ArticleCellType"];
    
    
    //Sets the background color when clicked to orange.
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    
    Article *currentArticle = [self.listOfArticles objectAtIndex:rowNumber];
    
    //extract all information from the current article.
    NSString *title = currentArticle.title;
    NSString *description = currentArticle.description;
    NSString *datePublished = currentArticle.datePublished;
    
    //Setting all the properties of the cell.
    cell.articleImage.clipsToBounds = YES;
    cell.titleLabel.text = title;
    cell.descriptionLabel.text = description;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.theKey = currentArticle.key;
    cell.dateLabel.text = datePublished;
    
    NSString *key = cell.theKey.description;
    
    //Image Cache - We first have to check to see if the image has already been downloaded before.
    if (self.ImagesCacheDictionary[key])
    {
        //If it is downloaded, we just retrieve the UIImage object from the dictionary
        cell.articleImage.image = self.ImagesCacheDictionary[key];
        
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:currentArticle.imageURL];
            
            
            __block NSData *imageData;
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                imageData = [NSData dataWithContentsOfURL:imageURL];
                
                UIImage *theImage = [UIImage imageWithData:imageData];
                
                if(theImage == nil){
                    theImage = [UIImage imageNamed:@"virginiatech-logo.jpg"];
                }
                
                [self.ImagesCacheDictionary setObject:theImage forKey:key];
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
//                    [cell.articleImage setImage:[self.ImagesCacheDictionary objectForKey:cell.theKey.description]];
                    [cell.articleImage setImage:theImage];
                });
            });
        });
        
    }
    return cell;
}



#pragma mark - Table View Delegate Methods

// Informs the table view delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Article *articleClicked = [[self.xmlParser listOfArticle] objectAtIndex:indexPath.row];
    
    NSString *key = articleClicked.key;
    
    //Setting the fields for the current cell clicked to be passed to the social web view controller.
    self.currentLinkFromCell = articleClicked.aLink;
    self.currentImageFromCell = [self.ImagesCacheDictionary objectForKey:key];
    self.currentTitleFromCell = articleClicked.title;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowWebView" sender:self];
    
}

#pragma mark - Preparing for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"ShowWebView"]){
        
        SocialWebViewController *socialWebViewController = [segue destinationViewController];
        
        //Pass the current cell clicked's link, image, and title.
        socialWebViewController.theLink = self.currentLinkFromCell;
        socialWebViewController.theImage = self.currentImageFromCell;
        socialWebViewController.theTitle = self.currentTitleFromCell;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end