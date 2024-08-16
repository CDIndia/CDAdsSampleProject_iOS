//
//  AppDelegate.m
//  CDAdsSample
//
//  Created by Arun Gupta on 07/01/18.
//  Copyright © 2018 Arun Gupta. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CDInitialisationParams *params = [[CDInitialisationParams alloc] init];
    params.partnerKey = @"ENTER YOUR CHALK DIGITAL PARTNER KEY HERE";           //Provided by Chalk Digital, would be used for tracking only.
    params.locationUpdateInterval = 30;                 //Set interval at which location update is required, default value is 900 seconds
    params.adLocationExpiryInterval = 300;               //Set time after which new location for ad request is required, default value is 120 seconds
    params.distanceFilter = 5.0;                         //Set distance after which you want SDK to record location update, default value is 100.0 meters
#ifdef DEBUG
    params.logLevel = CDLogLevelAll;                    //Set log level to see SDK logs, default value is CDLogLevelNone
#endif
    params.environment = CDEnvironmentProduction;             //Use CDEnvironmentTest for test environment and CDEnvironmentProduction fro production.
    params.applicationIABCategory = @"IAB15-10";         //IAB Category of application. In case of multiple IAB Categories use Comma (,) to separate different categories"
//    params.clientHasUserTrackingPermission = YES;
    _cdAds = [CDAds initialiseWithParams:params launchOptions:launchOptions enableTracking:YES];       // set enableTracking NO to disable device location tracking
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

-(void)initialiseWithLaunchOptions:(NSDictionary *)launchOptions{
    
}

@end
