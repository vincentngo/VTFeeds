//
//  SocialWebViewController.m
//  VTFeeds
//
//  Created by Vincent Ngo on 4/12/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "SocialWebViewController.h"

@interface SocialWebViewController ()

@end

@implementation SocialWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.theLink]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method that creates a new composeViewController for twitter.
- (void) showTwitterPostSheet{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //Inserting an initial text for the user. (Really cool because you can create automated messages for users)
        [tweetSheet setInitialText:@"Insert Tweet Message Here"];
        //Add a URL to an image, or a video, or even a web link to send to twitter.
        [tweetSheet addURL:[NSURL URLWithString:self.theLink]];
        //Adding an image to send to twitter... (In this case a particular article's image from Virginia Tech news Feeds)
        [tweetSheet addImage:self.theImage];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        //If your twitter account is not set up, its going to show an alert.
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

//Method that creates a new composeViewController for facebook.
-(void) showFacebookPostSheet{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        //Insert an initial text for the user.
        [facebookPost setInitialText:@"Insert Post here:"];
        //Insert a link to be posted on your facebook wall
        [facebookPost addURL:[NSURL URLWithString:self.theLink]];
        //Insert a photo to be posted on your facebook wall.
        [facebookPost addImage:self.theImage];
        
        [self presentViewController:facebookPost animated:YES completion:nil];
    }
    else
    {
        //If your facebook account is not set up, its goign to show an alert.
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//In the MFMailComposeViewController, you can set up an auto subject, auto message,
//and recipents you want to send to (useful for send to all contacts button)
-(void) openEmail{
    
    //Check the device you are using, is it able to send an email?
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        //Set the delegate, so it can respond to the delegate's methods.
        mail.mailComposeDelegate = self;
        
        //Setting the email subject tile.
        [mail setSubject:@"Check out this Article from Virginia Tech News!"];
        
        NSString *emailBody = [NSString stringWithFormat:@"Have you seen this article about: %@\n\n %@", self.theTitle, self.theLink];
        [mail setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mail animated:YES completion:nil];
        
        //Not able to send email on device, display an alert.
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Your device doesn't support emailing"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//This is for opening the messages app to send to your friends/family/etc...
//NOTE: This will not work on an iOS simulator, to test the message sending you must deploy to an iOS device.
//Calling this method in the iOS simulator will result in a blank screen.
-(void) openMessage{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"Check out this: %@", self.theLink];
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        //MF Message Compose View Controller actually have their own alert... SO we don't need to create one.
    }
}

#pragma mark - MF Message Compose View Controller Delegate Method

//http://stackoverflow.com/questions/9349381/mfmessagecomposeviewcontroller-on-simulator-cansendtext

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch(result){
        case MessageComposeResultSent:
            NSLog(@"message has been sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message has failed to send");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"Message has been cancelled");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - MF Mail Compose View Controller Delegate Method

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
            //With every result message, you can perform some action to respond to the user.
            //Just added print statements to show you which one has been called.
        case MFMailComposeResultCancelled:
            //NSLog(@"You pressed the cancel button, go back to app");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail has been saved to the draft folder of your mail app");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail has been sent.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail has failed to send, error");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIActionSheet Delegate Method

//There are three UIActionDelegate methods.

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //Perform one of these methods based on the button pressed.
    if  ([buttonTitle isEqualToString:@"Facebook"]) {
        
        //open facebook sheet
        [self showFacebookPostSheet];
        
    }
    if ([buttonTitle isEqualToString:@"Twitter"]) {
        
        //open twitter sheet
        [self showTwitterPostSheet];
        
    }
    if ([buttonTitle isEqualToString:@"Email"]) {
        
        //open email
        [self openEmail];
        
    }
    if ([buttonTitle isEqualToString:@"SMS"]) {
        
        //open messages
        [self openMessage];
        
    }
}


//This action method handles the share button of the Social Web View Controller.
- (IBAction)showShareOptions:(id)sender {
    
    //Creating a new actionSheet object, with the following buttons (Facebook, Twitter, Email, SMS
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Sharing Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Facebook", @"Twitter", @"Email", @"SMS", nil];
    
    //Makes the background of the action sheet a bit transparent.
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
    
}


#pragma mark - UIWebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //Starting to load the web page. Show the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Report the error inside the webview.
    NSString *errorString = [NSString stringWithFormat:@"<html><center><font size = +5 color='red'>An error occurred:<br>%@</font></center></html>", error.localizedDescription];
    
    [self.webView loadHTMLString:errorString baseURL:nil];
}

@end