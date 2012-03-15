//
//  AppDelegate.m
//  UDTableViewDemo
//
//  Created by Yasuhiro Inami on 12/03/13.
//  Copyright (c) 2012 Yasuhiro Inami. All rights reserved.
//

#import "AppDelegate.h"
#import "YIViewController.h"


@implementation AppDelegate {
    UIWindow *_window;
}


- (void)dealloc {
    [_window release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    YIViewController *viewController = [[[YIViewController alloc] init] autorelease];
    [_window setRootViewController: [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease]];
    [_window makeKeyAndVisible];
    
    return YES;
}


@end
