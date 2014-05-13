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
@property (strong) IBOutlet NSPanel *inputSheet;
@property (strong) IBOutlet NSPanel *outputSheet;
@property (weak) IBOutlet NSTextField *inputField;
@property (weak) IBOutlet NSTextField *outputField;

- (IBAction)step:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)editedField:(NSTextField *)sender;
- (IBAction)closeInputSheet:(id)sender;
- (IBAction)openInputSheet:(id)sender;
- (IBAction)closeOutputSheet:(id)sender;
@end
