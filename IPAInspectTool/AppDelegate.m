//
//  AppDelegate.m
//  IPAInspectTool
//
//  Created by wpsteak on 13/9/15.
//  Copyright (c) 2013年 Prince. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
	self.windowController = [[IPAWindowController alloc] initWithWindowNibName:@"IPAWindowController"];
	[self.windowController showWindow:self];
}

@end
