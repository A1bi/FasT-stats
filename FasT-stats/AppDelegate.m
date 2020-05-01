//
//  AppDelegate.m
//  FasT-stats
//
//  Created by Albrecht Oster on 10.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "AppDelegate.h"
#import "FasTApi.h"

@import UserNotifications;

@interface AppDelegate ()

- (void)updateRemoteRegistration:(NSString *)deviceToken;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError *error) {}];

    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceTokenData
{
    if (deviceTokenData.length < 1) return;

    NSMutableString *deviceToken = [NSMutableString string];
    const char *bytes = deviceTokenData.bytes;
    for (int i = 0; i < deviceTokenData.length; i++) {
        [deviceToken appendFormat:@"%02.2hhx", bytes[i]];
    }

    [self updateRemoteRegistration:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications with error: %@", error);
}

- (void)updateRemoteRegistration:(NSString *)deviceToken
{
    if (!deviceToken) {
        return;
    }
    
    BOOL soundEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEnabled"];
    NSDictionary *settings = @{@"sound_enabled": @(soundEnabled)};
    
    [[FasTApi defaultApi] registerDeviceTokenWithServer:@"stats" token:deviceToken settings:settings];
}

@end
