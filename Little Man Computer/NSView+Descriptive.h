//
//  NSView+Descriptive.h
//  Little Man Computer
//
//  Created by Dan Horwood on 14/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Descriptive)
+ (NSString *)hierarchicalDescriptionOfView:(NSView *)view
                                      level:(NSUInteger)level;
- (void)logHierarchy;
@end
