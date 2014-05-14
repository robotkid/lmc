//
//  highlightRingView.m
//  Little Man Computer
//
//  Created by Dan Horwood on 14/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import "HighlightRingView.h"

@implementation HighlightRingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor yellowColor] set];
    [NSBezierPath strokeRect:self.bounds];
}

@end
