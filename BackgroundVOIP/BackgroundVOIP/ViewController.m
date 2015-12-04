//
//  ViewController.m
//  BackgroundVOIP
//
//  Created by Jordan Zucker on 12/4/15.
//  Copyright © 2015 pubnub. All rights reserved.
//

#import <PubNub/PubNub.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController () <PNObjectEventListener>
@property (nonatomic, strong) PubNub *client;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [(AppDelegate *)[UIApplication sharedApplication].delegate client];
    [self.client addListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"message: %@", message.data.message);
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
