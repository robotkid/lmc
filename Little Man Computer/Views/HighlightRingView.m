//
//  highlightRingView.m
//  Little Man Computer
//
//  Created by Dan Horwood on 14/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import "HighlightRingView.h"

@interface HighlightRingView ()
@property NSBezierPath *path;
@end

@implementation HighlightRingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSRect insetFrame = NSInsetRect(self.bounds, 1.5, 1.5);
        _path = [NSBezierPath bezierPathWithRect:insetFrame];
        [_path setLineWidth:2.5];
        [_path setLineJoinStyle:NSRoundLineJoinStyle];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor yellowColor] set];
    [self.path stroke];
    [[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.0 alpha:0.2] set];
    [self.path fill];
}

- (NSView *) hitTest:(NSPoint)aPoint
{
    return nil;
}


@end
