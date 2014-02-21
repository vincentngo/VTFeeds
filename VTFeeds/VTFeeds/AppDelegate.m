//
//  AppDelegate.m
//  VTFeeds
//
//  Created by Vincent Ngo on 4/10/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*******************************
 CUSTOMIZE APPEARANCE
 ******************************/

-(void)customizeAppearance {
    /******************************
     NavigationBar customization
     *****************************/
    
    UIColor *red = [UIColor colorWithRed:163/255.0f
                                            green:29/255.0f
                                             blue:33/255.0f
                                            alpha:1.0f];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:red];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    /*
     
     For detailed information about how to "USER INTERFACE CUSTOMIZATION" in iOS please check the links at below
     
     http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html
     http://mobileorchard.com/how-to-make-your-app-stand-out-with-the-new-ios-5-appearance-api/
     http://www.raywenderlich.com/4344/user-interface-customization-in-ios-5
     http://mobiledevelopertips.com/user-interface/ios-5-customize-uinavigationbar-and-uibarbuttonitem-with-appearance-api.html
     
     */
}

@end
