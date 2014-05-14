//
//  Document.m
//  Little Man Computer
//
//  Created by Dan Horwood on 12/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import "Document.h"
#import "LittleManComputer.h"
#import "HighlightRingView.h"
#import "NSView+Descriptive.h"

@interface Document ()
@property NSInteger inputNumber;
@property HighlightRingView *highlight;
@end


@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        _lmc = [[LittleManComputer alloc] initWithData:@[@10,@20]];
        _lmc.delegate = self;
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self.tableView reloadData];
    self.highlight = [[HighlightRingView alloc] initWithFrame:[self.tableView rectOfRow:0]];
    self.highlight.tableView = self.tableView;
    [[self.tableView superview] addSubview:self.highlight positioned:NSWindowAbove relativeTo:self.tableView];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

#define ANIMATION_DURATION 0.8
- (void)updateHighlight
{
    NSViewAnimation *anim;
    NSRect fromFrame = [self.highlight frame];
    NSRect toFrame = [self.tableView rectOfRow:self.lmc.pc];
    NSDictionary *viewDict = @{NSViewAnimationTargetKey: self.highlight,
                                      NSViewAnimationStartFrameKey: [NSValue valueWithRect:fromFrame],
                                      NSViewAnimationEndFrameKey: [NSValue valueWithRect:toFrame]};
    
    anim = [[NSViewAnimation alloc] initWithViewAnimations:@[viewDict]];
    //[anim setAnimationCurve:NSAnimationEaseIn];
    [anim setDuration:ANIMATION_DURATION];
    [anim startAnimation];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    if ([[tableColumn identifier] isEqualToString:@"LocationColumn"]) {
        [cellView.textField setObjectValue:@(row)];
    }
    else if ([[tableColumn identifier] isEqualToString:@"ValueColumn"]) {
        [cellView.textField setObjectValue:self.lmc.memory[row]];
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.lmc.size;
}

- (void)getInput
{
    [self openInputSheet:self];
}

- (void)putOutput:(NSNumber *)value
{
    NSLog(@"Output: %ld", [value longValue]);
    [self.outputField setIntegerValue:[value integerValue]];
    [self openOutputSheet:self];
}

- (void)panic:(NSString *)reason
{
    NSLog(@"PANIC: %@", reason);
}

- (IBAction)step:(id)sender {
    [self.lmc step];
    [self.tableView reloadData];
    [self updateHighlight];
}

- (IBAction)reset:(id)sender {
    [self.lmc reset];
    [self.tableView reloadData];
}

- (IBAction)editedField:(NSTextField *)sender {
    NSInteger row = [self.tableView selectedRow];
    [self.lmc setValue:[sender integerValue] atMemoryLocation:row];
    [self.tableView reloadData];
}

- (IBAction)closeInputSheet:(id)sender {
    [self.lmc returnInput:[self.inputField integerValue]];
    [self.inputSheet orderOut:nil];
    [NSApp endSheet:self.inputSheet];
}

- (IBAction)openInputSheet:(id)sender {
    [NSApp beginSheet:self.inputSheet modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (void)openOutputSheet:(id)sender {
    [NSApp beginSheet:self.outputSheet modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)closeOutputSheet:(id)sender {
    [self.outputSheet orderOut:nil];
    [NSApp endSheet:self.outputSheet];
}

@end
