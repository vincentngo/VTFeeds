//
//  ViewController.h
//  VTFeeds
//
//  Created by Vincent Ngo on 4/10/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"

@interface ViewController : UITableViewController

//our parser that parses the virginia tech news feed.
@property (nonatomic, strong)XMLParser *xmlParser;

//Going to store the downloaded images into a Dictionary.
@property (atomic, strong)NSMutableDictionary *ImagesCacheDictionary;

//Contains all the article objects.
@property (atomic, strong)NSMutableArray *listOfArticles;

//Storing the current link, image, and title to be passed to another view.
@property (nonatomic, strong) NSString *currentLinkFromCell;
@property (nonatomic, strong) UIImage *currentImageFromCell;
@property (nonatomic, strong) NSString *currentTitleFromCell;

@end

