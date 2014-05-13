//
//  Document.h
//  Little Man Computer
//
//  Created by Dan Horwood on 12/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LittleManComputer;

@interface Document : NSDocument <NSTableViewDataSource, NSTableViewDelegate>

@property LittleManComputer *lmc;
@property (weak) IBOutlet NSTableView *tableView;

@end
