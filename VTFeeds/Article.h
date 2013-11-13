//
//  Article.h
//  VTFeeds
//
//  Created by Vincent Ngo on 4/12/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *aLink;

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *datePublished;
@property (nonatomic, strong) NSString *imageURL;
@property (strong, nonatomic) NSString *key;

@end
