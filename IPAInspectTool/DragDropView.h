//
//  DragDropView.h
//  IPAInspectTool
//
//  Created by wpsteak on 13/9/15.
//  Copyright (c) 2013年 Prince. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DragDropViewProtocol <NSObject>

- (BOOL)dragDropViewDidAcceptIpaFile:(id <NSDraggingInfo>)sender;

@end

@interface DragDropView : NSImageView <NSDraggingDestination>

@property(nonatomic, assign) IBOutlet id <DragDropViewProtocol>delegate;

- (id)initWithCoder:(NSCoder *)coder;

@end
