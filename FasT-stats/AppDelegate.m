//
//  AppDelegate.m
//  FasT-stats
//
//  Created by Albrecht Oster on 10.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "AppDelegate.h"
#import "FasTApi.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[FasTApi defaultApi] registerDeviceTokenWithServer:tokenString];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications with error: %@", error);
}

@end
