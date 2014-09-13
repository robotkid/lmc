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

#define LMCErrorDomain (@"org.muruk.lmc")


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
    NSMutableString *output = [[NSMutableString alloc] init];    
    BOOL writeAddress = NO;
    NSNumber *previous = nil;

    for (int i = 0; i < [self.lmc size]; i++) {
        NSNumber *value = self.lmc.memory[i];

        if (previous && [value isEqualToNumber:previous]) {
            writeAddress = YES;
        }
        else {
            if (writeAddress) {
                [output appendString:[NSString stringWithFormat:@"%d:", i]];
                writeAddress = NO;
            }
            [output appendString:[NSString stringWithFormat:@"%d\n", [value intValue]]];
        }
        previous = value;
    }
    
    return [output dataUsingEncoding:NSUTF8StringEncoding];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return YES;

    BOOL readSuccess = NO;
    
    NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!fileContents && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:NSFileReadUnknownError userInfo:nil];
    }
    
    if (fileContents) {
        readSuccess = YES;
        NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
        NSInteger index = 0;
        for (NSString *line in lines) {
            if ([line length] == 0) {
                continue;
            }
            
            NSInteger location = 0;
            NSInteger value = 0;

            if (![self getLocation:&location andValue:&value fromLine:line]) {
                readSuccess = NO;
                break;
            }
            
            if (location != 0) {
                if (location < index) {
                    readSuccess = NO;
                    break;
                }
                else {
                    index = location;
                }
            }

            [self.lmc setValue:value atMemoryLocation:index];
            index++;
        }
    }
    
    if (!readSuccess) {
        if (outError != NULL) {
            NSDictionary *info = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"syntax error", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"not up to par", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ensure correct format", nil),
                                   };
            *outError = [NSError errorWithDomain:LMCErrorDomain code:1 userInfo:info];
        }
    }
    
    return readSuccess;
}

/**
  * Returns YES if valid line and NO on a syntax error
  * loc is unchanged if not present in the line
  * value is set to the value in the line
  * format is location:value
  * location must be between 0 and 99 inclusive
  * value must be between -999 and 999 inclusive
 **/
- (BOOL)getLocation:(NSInteger *)loc andValue:(NSInteger *)val fromLine:(NSString *)line
{
    NSInteger temploc;
    NSInteger tempval;
    
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSRange range = [line rangeOfString:@":"];

    if (range.location != NSNotFound) {
        if (![scanner scanInteger:&temploc]) {
            // No integer at the beginning of the line - syntax error
            return NO;
        }
        
        [scanner scanString:@":" intoString:NULL];
        
        if (temploc < 0 || temploc > 99) {
            return NO;
        }
        *loc = temploc;
    }
    
    if (![scanner scanInteger:&tempval])
        return NO;
    
    if (tempval < -999 || tempval > 999)
        return NO;
    
    *val = tempval;
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
    [self updateHighlight];
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
