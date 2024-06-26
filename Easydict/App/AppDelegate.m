//
//  AppDelegate.m
//  Easydict
//
//  Created by tisfeng on 2022/10/30.
//  Copyright © 2023 izual. All rights reserved.
//

#import "AppDelegate.h"
#import "EZShortcut.h"
#import "MMCrash.h"
#import "AppDelegate+EZURLScheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MMLogInfo(@"程序启动");
    
    // Capturing crash logs must be placed first.
    [MMCrash registerHandler];
    
    [EZLog setupCrashLogService];
    [EZLog logAppInfo];

    if (!Configuration.shared.enableBetaNewApp) {
        [EZMenuItemManager.shared setup];
        [EZShortcut setup];
    } else {
        [Shortcut setupShortcut];
    }

    [EZWindowManager.shared showMainWindowIfNeeded];
    
    [self registerRouters];
    
    [[DarkModeManager manager] updateDarkMode:Configuration.shared.appearance];
    // Change App icon manually.
    //    NSApplication.sharedApplication.applicationIconImage = [NSImage imageNamed:@"white-black-icon"];
}

- (void)restartApplication {
    NSApplication *application = [NSApplication sharedApplication];
    [application terminate:nil];
    
    // Relaunch app.
    NSString *launchPath = @"/usr/bin/open";
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSArray *arguments = @[bundlePath];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:launchPath];
    [task setArguments:arguments];
    [task launch];
}

#pragma mark - NSApplicationDelegate

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[EZMenuItemManager shared] remove];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application {
    return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    // Fix https://github.com/tisfeng/Easydict/issues/447
    [EZWindowManager.shared showMainWindowIfNeeded];
    
    return YES;
}

@end
