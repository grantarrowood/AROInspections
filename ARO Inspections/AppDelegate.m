//
//  AppDelegate.m
//  ARO Inspections
//
//  Created by Grant Arrowood on 12/12/16.
//  Copyright © 2016 Piglet Products. All rights reserved.
//

#import "AppDelegate.h"
@import HockeySDK;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"833228551e43405b9832985c8f03f6c8"];
    [[BITHockeyManager sharedHockeyManager] startManager]; [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [DropboxClientsManager setupWithAppKey:@"wntgrbueldo53jd"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSString stringWithFormat:@"1cBWAKZxTMT934OanqsHkhsWMIEuWarHPdb_StalVz6s"] forKey:@"SpreadsheetID"];
        [defaults synchronize];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
    return NO;
}


@end
