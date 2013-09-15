//
//  DragDropView.m
//  IPAInspectTool
//
//  Created by wpsteak on 13/9/15.
//  Copyright (c) 2013年 Prince. All rights reserved.
//

#import "DragDropView.h"

@implementation DragDropView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:@[@"com.apple.iTunes.ipa", NSFilenamesPboardType]];
    }
    return self;
}

-(void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    [[NSColor colorWithCalibratedWhite:0.174 alpha:1.000] setFill];
    NSRectFill(rect);
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    
    return [self.delegate dragDropViewDidAcceptIpaFile:sender];
}

@end
