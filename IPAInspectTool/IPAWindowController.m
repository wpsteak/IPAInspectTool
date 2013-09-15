//
//  IPAWindowController.m
//  IPAInspectTool
//
//  Created by wpsteak on 13/9/15.
//  Copyright (c) 2013年 Prince. All rights reserved.
//

#import "IPAWindowController.h"
#import "SSZipArchive.h"
#import "DragDropView.h"

#define IPAInspectToolName @"IPAInspectTool"

@interface IPAWindowController () <DragDropViewProtocol>

@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSImageView *iconImageView2;
@property (weak) IBOutlet NSTableView *tableView;

@property (strong)  NSDictionary *infoDictionary;
@property (readonly)NSString *tempDirPath;
@end

@implementation IPAWindowController

- (NSString *)tempDirPath {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/",IPAInspectToolName]];
    
    return path;
}

#pragma mark - DragDropViewProtocol

- (BOOL)dragDropViewDidAcceptIpaFile:(id <NSDraggingInfo>)sender {

    if ([sender draggingSource] == self) {
        return NO;
    }
    
    NSURL *ipaURL = [NSURL URLFromPasteboard:[sender draggingPasteboard]];
    NSString *destinationPath = [self.tempDirPath stringByAppendingPathComponent:IPAInspectToolName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
    }
    
    NSString *zipPath = [[ipaURL absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
    NSError *error;
    BOOL isUnzip = [SSZipArchive unzipFileAtPath:[zipPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toDestination:destinationPath overwrite:YES password:nil error:&error];
    if (!isUnzip) {
        return NO;
    }
    
    NSString *zipFileName = IPAInspectToolName;
    NSString *zippedDBPath = [self.tempDirPath stringByAppendingPathComponent:zipFileName];
    zippedDBPath = [zippedDBPath stringByAppendingPathComponent:@"Payload"];
    
    NSArray *fileURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath: zippedDBPath] includingPropertiesForKeys:@[@".app"] options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    self.infoDictionary = nil;
    if ([fileURLs count] > 0) {
        NSURL *destinationPath = [[fileURLs objectAtIndex:0] URLByAppendingPathComponent:@"Info.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:destinationPath];
        self.infoDictionary = dict;
                
        [self reloadData];
    }
    
    return YES;
}

#pragma mark - 

- (void)reloadData {
    [self.window setTitle:[self.infoDictionary objectForKey:@"CFBundleDisplayName"]];

    NSString *upZipPath = [self.tempDirPath stringByAppendingPathComponent:IPAInspectToolName];
    upZipPath = [upZipPath stringByAppendingPathComponent:@"Payload"];
    
    NSArray *appURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:upZipPath] includingPropertiesForKeys:@[@".app"] options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    if (appURLs == nil)  {
        return;
    }
    
    NSURL *bundleBasePath = [appURLs objectAtIndex:0];
    NSImage *image1 = [[NSImage alloc] initWithContentsOfURL:[bundleBasePath URLByAppendingPathComponent:@"Icon.png"]];
    [self.iconImageView setImage:image1];
    
    NSImage *image2 = [[NSImage alloc] initWithContentsOfURL:[bundleBasePath URLByAppendingPathComponent:@"Icon@2x.png"]];
    [self.iconImageView2 setImage:image2];

    [self.tableView reloadData];
}

#pragma mark - NSTableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self.infoDictionary allKeys] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *allKey = [self.infoDictionary allKeys];
    NSArray *sortedArray = [allKey sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *keyName = [sortedArray objectAtIndex:row];
    
    if ([@"KeyName" isEqualToString:[tableColumn identifier]]) {
        return keyName;
    }
    else {
        return [self.infoDictionary objectForKey:keyName];
    }
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

@end
