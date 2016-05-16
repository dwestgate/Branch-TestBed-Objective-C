//
//  AppDelegate.m
//  Branch-TestBed
//
//  Created by Alex Austin on 6/5/14.
//  Copyright (c) 2014 Branch Metrics. All rights reserved.
//
#import "Branch.h"
#import "AppDelegate.h"
#import "LogOutputViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // APNS support: different between ios7 and ios8+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    // end APNS support
    
    
    Branch *branch = [Branch getInstance];
    [branch setDebug];
    [branch setDeepLinkDebugMode:@{@"example_debug_param" : @"foo"}];
    
    LogOutputViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LogOutputViewController"];
    
    [branch registerDeepLinkController:controller forKey:@"deepview_text"];
    [branch initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:YES];
    /*
    [branch initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:YES deepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error) {
            NSLog(@"Branch TestBed: finished init with params = %@", [params description]);
        }
        else {
            NSLog(@"Branch TestBed: TestBed failed init: %@", error);
        }
    }];*/
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Branch TestBed: Opened app from URL %@", [url description]);
    
    return [[Branch getInstance] handleDeepLink:url];
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}


//APNS support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[Branch getInstance] handlePushNotification:userInfo];
    
    //process your other notification payload items...
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Branch TestBed: APN device token: %@", deviceToken);
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Branch TestBed: Error registering for remote notifications:%@",error);
}
//end APNS support


@end
