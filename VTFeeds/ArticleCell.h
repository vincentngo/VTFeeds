//
//  ArticleCell.h
//  VTFeeds
//
//  Created by Vincent Ngo on 4/12/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *articleImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *theKey;


@end
