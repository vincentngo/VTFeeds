//
//  SocialWebViewController.h
//  VTFeeds
//
//  Created by Vincent Ngo on 4/12/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

//Declaring 3 different delegation, one for the ActionSheet menu, one of the messages app, and one for the mail app.
@interface SocialWebViewController : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *theLink;
@property (strong, nonatomic) UIImage *theImage;
@property (strong, nonatomic) NSString *theTitle;

- (IBAction)showShareOptions:(id)sender;


@end
