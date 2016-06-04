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
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if ([notificationSettings types] != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceTokenData
{
    deviceToken = [[[[deviceTokenData description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
    [self updateRemoteRegistration];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications with error: %@", error);
}

- (void)updateRemoteRegistration
{
    if (!deviceToken) {
        return;
    }
    
    BOOL soundEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEnabled"];
    NSDictionary *settings = @{@"sound_enabled": @(soundEnabled)};
    
    [[FasTApi defaultApi] registerDeviceTokenWithServer:@"stats" token:deviceToken settings:settings];
}

- (void)dealloc
{
    [deviceToken release];
    [super dealloc];
}

@end
