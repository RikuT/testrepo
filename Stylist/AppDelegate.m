//
//  AppDelegate.m
//  Stylist
//
//  Created by Kenty on 2015/06/26.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Rover/Rover.h>
#import "ParseCrashReporting/ParseCrashReporting.h"



@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse enableLocalDatastore];
    // Enable Crash Reporting
    [ParseCrashReporting enable];

    
    // Initialize Parse.
    [Parse setApplicationId:@"ZEczNFa87TVNAqxZWtIacRXzcxpRHscd5M2CbKrz"
                  clientKey:@"giGCYLa2fAxnZMn9CgvgaUUZ4xsFmxjmei6DEH6n"];
    

    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
        return YES;
    
    RVConfig *config = [RVConfig defaultConfig];
    config.applicationToken = @"<ba1b7681897651674c46b5adf5e0f9ed>";
    [config addBeaconUUID:@"<9E51D480-9270-44D0-AC79-7F874C0123CA>"];
    
    Rover *rover = [Rover setup:config];
    [rover startMonitoring];
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}




- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[Rover shared] handleDidReceiveLocalNotification:notification]) {
        return;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
