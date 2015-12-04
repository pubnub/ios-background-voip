//
//  AppDelegate.m
//  BackgroundVOIP
//
//  Created by Jordan Zucker on 12/4/15.
//  Copyright © 2015 pubnub. All rights reserved.
//

#import <PubNub/PubNub.h>
#import "AppDelegate.h"

NSString * const kPNPubKey = @"demo-36";
NSString * const kPNSubKey = @"demo-36";

@interface AppDelegate () <PNObjectEventListener>
@property (nonatomic, strong) dispatch_queue_t pubNubQueue;
- (void)startPubNub;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.pubNubQueue = dispatch_queue_create("com.PubNub.callbackQueue", DISPATCH_QUEUE_SERIAL);
    PNConfiguration *config = [PNConfiguration configurationWithPublishKey:kPNPubKey subscribeKey:kPNSubKey];
    config.TLSEnabled = YES;
    config.VoIPEnabled = YES;
    self.client = [PubNub clientWithConfiguration:config callbackQueue:self.pubNubQueue];
    [self.client addListener:self];
    [self startPubNub];
    
    __weak typeof (self) wself = self;
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"we woke up!");
        __strong typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        [sself startPubNub];
    }];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - PubNub Helper Methods

- (void)startPubNub {
    if ([self.client isSubscribedOn:@"a"]) {
        return;
    }
    [self.client subscribeToChannels:@[@"a"] withPresence:YES];
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"message: %@", message.data.message);
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertTitle = @"Phone Call!";
        id messagePayload = message.data.message;
        NSString *alertBody = nil;
        if ([messagePayload isKindOfClass:[NSString class]]) {
            alertBody = messagePayload;
        } else if ([messagePayload isKindOfClass:[NSDictionary class]]) {
            // if this comes from the console in a typical console json payload, pull out the text
            if (messagePayload[@"text"]) {
                alertBody = messagePayload[@"text"];
            }
        } else {
            // We can't easily decode message, up to you
            alertBody = @"You are getting a call!";
        }
        localNotification.alertBody = alertBody;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"status: %@", status.stringifiedCategory);
    NSLog(@"status: %@", status.stringifiedOperation);
}

@end
