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
//    NSLog(@"bounds xy %1f %1f", self.bounds.origin.x, self.bounds.origin.y);
//    NSLog(@"bounds wh %1f %1f", self.bounds.size.width, self.bounds.size.height);
//    NSLog(@"frame  xy %1f %1f", self.frame.origin.x, self.frame.origin.y);
//    NSLog(@"frame  wh %1f %1f", self.frame.size.width, self.frame.size.height);
}

- (NSView *) hitTest:(NSPoint)aPoint
{
    return nil;
}


@end
