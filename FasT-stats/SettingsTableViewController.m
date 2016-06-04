//
//  SettingsTableViewController.m
//  FasT-stats
//
//  Created by Albrecht Oster on 04.06.16.
//  Copyright © 2016 Albisigns. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@property (retain, nonatomic) IBOutlet UISwitch *soundEnabledSwitch;

- (IBAction)soundEnabledChanged:(id)sender;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL soundEnabled;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"soundEnabled"] != nil) {
        soundEnabled = [defaults boolForKey:@"soundEnabled"];
    } else {
        [defaults setBool:YES forKey:@"soundEnabled"];
        soundEnabled = YES;
    }
    
    [_soundEnabledSwitch setOn:soundEnabled];
}

- (IBAction)soundEnabledChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[_soundEnabledSwitch isOn] forKey:@"soundEnabled"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateRemoteRegistration];
}

- (void)dealloc {
    [_soundEnabledSwitch release];
    [super dealloc];
}

@end
